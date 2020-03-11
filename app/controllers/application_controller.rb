class ApplicationController < ActionController::Base
  include Authenticable

  after_action :clean_authentication_credentials!
  helper_method :current_user

  rescue_from Faraday::UnprocessableEntityError, with: :api_unprocessable_entity_error

  private

    def api_unprocessable_entity_error(exception)
      message = exception.response.dig(:body, :message)

      if action_name != 'index'
        redirect_to root_path, flash: { error: message }
      end
    end
end
