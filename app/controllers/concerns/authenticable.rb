module Authenticable
  extend ActiveSupport::Concern

  included do
    def access_token
      @access_token
    end

    def user_signed_in?
      @access_token.present?
    end

    def current_user
      @current_user
    end

    def load_session
      token_data = session.dig('user', 'access_token')

      if token_data
        @access_token = ShowoffOauth.new.access_token_from_session(session[:user])
        @access_token.refresh! if @access_token.expired?

        Authentication.access_token = @access_token
        Authentication.oauth2_client = @access_token.client

        @current_user = User.find('me')
      end
    end

    def authenticate_user!
      token_data = session.dig(:user, :access_token)
      return redirect_to '/' unless token_data

      @access_token = ShowoffOauth.new.access_token_from_session(session[:user])
      @access_token.refresh! if @access_token.expired?
    end
  end
end
