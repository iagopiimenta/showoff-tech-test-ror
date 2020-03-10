module Helpers
  def authorize!
    FakeShowoff.valid_token = 'valid'
    access_token_hash[:access_token] = 'valid'

    FakeShowoff.client_id = Rails.application.config.x.showoff[:client_id]
    FakeShowoff.client_secret = Rails.application.config.x.showoff[:client_secret]

    Authentication.access_token = ShowoffOauth.new.access_token_from_session(access_token_hash)
    Authentication.oauth2_client = Authentication.access_token.client
  end

  def unauthorize!
    FakeShowoff.valid_token = 'valid'
    access_token_hash[:access_token] = 'invalid'

    Authentication.access_token = ShowoffOauth.new.access_token_from_session(access_token_hash)
    Authentication.oauth2_client = Authentication.access_token.client
  end
end
