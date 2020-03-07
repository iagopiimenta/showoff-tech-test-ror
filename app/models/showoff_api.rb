class ShowoffApi
  def initialize(access_token)
    @access_token = access_token
  end

  def widgets
    resource[:widgets]
  end

  def users
    resource[:users]
  end

  private

    attr_reader :access_token

    def resource
      RestClient::Resource.new(
        "#{Rails.application.config.x.showoff[:api_url]}/api/v1",
        headers: {
          Authorization: "Bearer #{fetch_token}"
        },
        log: Logger.new(STDOUT)
      )
    end

    def fetch_token
      access_token.refresh! if access_token.expired?
      access_token.token
    end
end
