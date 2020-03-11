class HomeController < ApplicationController
  include Authenticable

  before_action :load_session

  helper_method :current_user

  def index
    @widgets = Widget.only_visible
  end
end
