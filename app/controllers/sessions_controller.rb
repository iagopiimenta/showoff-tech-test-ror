class SessionsController < ApplicationController
  def create
    token = ShowoffOauth.new.create_token(
      user_params[:email],
      user_params[:password]
    )

    token_data = ShowoffOauth.convert_token_to_hash(token)

    session[:user] = token_data

    redirect_to root_path
  rescue OAuth2::Error => e
    # {"code":3,"message":"There was an error logging in. Please try again.","data":null}
    redirect_to new_session_path, flash: { error: "Invalid email or password" }
  end

  def sign_out
    reset_session

    redirect_to root_path
  end

  private

    def user_params
      params.require(:user).permit(:email, :password)
    end
end
