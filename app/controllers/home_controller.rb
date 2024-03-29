class HomeController < ApplicationController
  include Authenticable

  before_action :load_session

  def index
    @search_term = search_params[:widget_term] if params[:search]
    @widgets = Widget.only_visible(@search_term)
  end

  private

    def search_params
      params.require(:search).permit(
        :widget_term
      )
    end
end
