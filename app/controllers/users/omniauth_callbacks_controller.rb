# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end
  def google_oauth2
    if session["devise.omniauth_data"].present?
      session["devise.omniauth_data"].clear
    end
    @omniauth_env = request.env['omniauth.auth']
    @user = User.find_by(provider: @omniauth_env.provider, uid: @omniauth_env.uid)
    if @user.present?
      sign_in_and_redirect @user, event: :authentication
      session[:user_id] = @user.id
    else
      session['devise.omniauth_data'] = request.env["omniauth.auth"].except('extra')
      redirect_to user_value_set_users_path
    end
  end
  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
