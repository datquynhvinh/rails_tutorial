# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:google]

  def google_oauth2
    auth_data = request.env["omniauth.auth"]
    @user = User.from_omniauth(auth_data)

    if @user.persisted?
      unless @user.deleted_at.nil?
        flash[:notice] = 'User is deleted!'
        redirect_to new_user_registration_url
      else
        @user.save(name: auth_data["info"]["name"], email: auth_data["info"]["email"], provider: auth_data.provider, uid: auth_data.uid)
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
        sign_in_and_redirect @user, :event => :authentication
      end
    else
      session["devise.google_data"] = auth_data.select { |k, v| k == "email" }
      redirect_to new_user_registration_url
    end
  end

  # You should also create an action method in this controller like this:
  # def twitter
  # end

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
