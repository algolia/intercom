class HomeController < ApplicationController
  unless Rails.env.development?
    force_ssl
    http_basic_authenticate_with :name => ENV['ADMIN_USER'], :password => ENV['ADMIN_PASSWORD']
  end

  def index
  end
end
