class WidgetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @search_term = search_parms[:widget_term] if params[:search]
    @widgets = Widget.by_user_id(user_id, @search_term)
  end

  # TODO: add validations and rescue errors
  def destroy
    Widget.destroy!(params[:id])

    redirect_to widgets_path
  end

  def edit
    @widget = Widget.find(params[:id])
  end

  private

    def user_id
      params[:user_id].presence || 'me'
    end

    def search_parms
      params.require(:search).permit(
        :widget_term
      )
    end
end
