class Authentication
  thread_mattr_accessor :access_token, :oauth2_client

  def self.api_base_url
    "#{Rails.application.config.x.showoff[:api_url]}/api/v1"
  end
end
