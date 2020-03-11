class UsersController < ApplicationController
  before_action :load_session

  def create
    @user = User.new(user_params)

    if @user.create!
      token_data = ShowoffOauth.convert_token_to_hash(@user.token)
      session[:user] = token_data

      redirect_to root_path
    else
      redirect_to root_path, flash: { error: @user.errors.full_messages.to_sentence }
    end
  end

  def sign_in
    token = ShowoffOauth.new.create_token(
      sign_in_params[:email],
      sign_in_params[:password]
    )

    token_data = ShowoffOauth.convert_token_to_hash(token)

    session[:user] = token_data

    redirect_to root_path
  rescue OAuth2::Error => e
    # {"code":3,"message":"There was an error logging in. Please try again.","data":null}
    redirect_to root_path, flash: { error: "Invalid email or password" }
  end

  def sign_out
    reset_session

    redirect_to root_path
  end

  private

    def sign_in_params
      params.require(:user).permit(:email, :password)
    end

    def user_params
      params.require(:user).permit(
        :first_name,
        :last_name,
        :date_of_birth,
        :email,
        :password,
        :image_url
      )
    end
end
