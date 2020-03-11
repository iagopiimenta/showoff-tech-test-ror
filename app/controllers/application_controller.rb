class ApplicationController < ActionController::Base
  include Authenticable

  after_action :clean_authentication_credentials!
  helper_method :current_user
end
