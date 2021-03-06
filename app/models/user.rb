class User

  BATCH_SIZE = 10000

  def self.reindex!
    records = []
    index = Algolia::Index.new("#{ENV['ALGOLIA_INDEX']}.tmp")
    index.set_settings attributesToIndex: ['name', 'email', 'social_profiles.username', 'location_data.city_name', 'location_data.country_name'],
      customRanking: ['desc(session_count)'],
      queryType: 'prefixAll'
    sanitizer = HTML::FullSanitizer.new
    Intercom::User.all.each do |user|
      record = user.to_hash
      record['objectID'] = record.delete('intercom_id')
      record['social_profiles'] = user.social_profiles.map { |profile| JSON.parse(profile.to_json) }
      record['location_data'] = user.location_data
      records << sanitize(record, sanitizer)
      if records.size > BATCH_SIZE
        index.add_objects records
        records = []
      end
    end
    index.add_objects records unless records.empty?
    Algolia.move_index index.name, ENV['ALGOLIA_INDEX']
  end

  private
  def self.sanitize(v, sanitizer)
    case v
    when String
      sanitizer.sanitize(v)
    when Hash
      v = v.dup # work-around frozen hash
      v.each { |key, value| v[key] = sanitize(value, sanitizer) }
    when Array
      v.map { |x| sanitize(x, sanitizer) }
    else
      v
    end
  end

end
