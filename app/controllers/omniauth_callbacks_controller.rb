class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def all
    #raise request.env["omniauth.auth"].to_yaml
    user = User.from_omniauth(request.env["omniauth.auth"])
    session["devise.user_attributes"]= user.attributes
    if user.persisted?
      flash[:notice] = "Successfully signed in!"
      sign_in_and_redirect user
    else

      redirect_to new_user_registration_path

    end
  end

  alias_method :twitter, :all
  alias_method :facebook, :all

end
