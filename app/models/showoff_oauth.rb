class ShowoffOauth
  def create_token(username, password)
    client.password.get_token(username, password)
  end

  def revoke_token(token)
    oauth_resource.post(
      token: token
    )
  end

  def access_token_from_session(hash)
    OAuth2::AccessToken.from_hash(client, hash)
  end

  private

    def oauth_resource
      resource[:oauth]
    end

    def resource
      RestClient::Resource.new(
        Rails.application.config.x.showoff[:api_url]
      )
    end

    # rubocop:disable Metrics/AbcSize
    def client
      OAuth2::Client.new(
        Rails.application.config.x.showoff[:client_id],
        Rails.application.config.x.showoff[:client_secret],
        :site => Rails.application.config.x.showoff[:api_url]
      )
    end
  # rubocop:enable Metrics/AbcSize
end
