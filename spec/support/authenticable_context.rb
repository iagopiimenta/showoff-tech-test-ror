RSpec.shared_context "authenticable_api" do
  let(:access_token_hash) do
    {
      access_token: 'valid',
      refresh_token: 'refresh_token',
      expires_in: 6.hours.to_i,
      expires_at: 6.hours.from_now.to_i
    }
  end

  before do
    FakeShowoff.client_id = Rails.application.config.x.showoff[:client_id]
    FakeShowoff.client_secret = Rails.application.config.x.showoff[:client_secret]

    Authentication.access_token = ShowoffOauth.new.access_token_from_session(access_token_hash)
    Authentication.oauth2_client = Authentication.access_token.client

    stub_request(:any, /#{Authentication.api_base_url}/).to_rack(FakeShowoff)
  end
end
