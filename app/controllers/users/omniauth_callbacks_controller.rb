class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)

    if @user.present? && @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_user_session_path, :alert=> 'No user account is associated with this email'
    end
  end

  def fluxapp
    @user = User.find_by_email(request.env["omniauth.auth"].info.email)
    if @user.present? && @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Flux"
      sign_in_and_redirect @user, :event => :authentication
    else
      #session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_user_session_path, :alert=> 'No user account is associated with this email'
    end
  end
end