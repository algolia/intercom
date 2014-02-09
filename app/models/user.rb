class User

  BATCH_SIZE = 10000

  def self.reindex!
    records = []
    index = Algolia::Index.new ENV['ALGOLIA_INDEX']
    index.set_settings attributesToIndex: ['name', 'email', 'social_profiles.username', 'location_data.city_name'],
      customRanking: ['desc(session_count)'],
      queryType: 'prefixAll'
    Intercom::User.all.each do |user|
      record = user.to_hash
      record['objectID'] = record.delete('intercom_id')
      record['social_profiles'] = user.social_profiles.map { |profile| JSON.parse(profile.to_json) }
      record['location_data'] = user.location_data
      records << record
      if records.size > BATCH_SIZE
        index.add_objects records
        records = []
      end
    end
    index.add_objects records unless records.empty?
  end

end
