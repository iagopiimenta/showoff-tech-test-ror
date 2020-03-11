class WidgetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @search_term = search_params[:widget_term] if params[:search]
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

  def update
    widget = Widget.new(
      widget_params.merge(id: params[:id])
    )

    widget.update!

    redirect_to widgets_path
  end

  def new
    @widget = Widget.new
  end

  private

    def user_id
      params[:user_id].presence || 'me'
    end

    def search_params
      params.require(:search).permit(
        :widget_term
      )
    end

    def widget_params
      params.require(:widget).permit(
        :name,
        :description,
        :kind
      )
    end
end
