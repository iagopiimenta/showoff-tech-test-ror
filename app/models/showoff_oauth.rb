class ShowoffOauth
  def create_token(username, password)
    self.class.default_client.password.get_token(username, password)
  end

  def revoke_token(token)
    oauth_resource.post(
      token: token
    )
  end

  def access_token_from_session(hash)
    OAuth2::AccessToken.from_hash(self.class.default_client, hash)
  end

  def self.convert_token_to_hash(token)
    {
      access_token: token.token,
      refresh_token: token.refresh_token,
      expires_in: token.expires_in,
      expires_at: token.expires_at
    }
  end

  # rubocop:disable Metrics/AbcSize
  def self.default_client
    OAuth2::Client.new(
      Rails.application.config.x.showoff[:client_id],
      Rails.application.config.x.showoff[:client_secret],
      site: Rails.application.config.x.showoff[:api_url]
    )
  end
  # rubocop:enable Metrics/AbcSize

  private

    def oauth_resource
      resource[:oauth]
    end

    def resource
      RestClient::Resource.new(
        Rails.application.config.x.showoff[:api_url]
      )
    end
end
