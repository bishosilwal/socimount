class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env['omniauth.auth'])
    @user = fill_user_data(@user, request)
    check_persisted_and_redirect(@user, 'facebook')
  end

  def twitter
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env['omniauth.auth'])
    @user = fill_user_data(@user, request)
    @user.consumer_key = request.env['omniauth.auth'].extra.access_token.consumer.key
    @user.consumer_secret = request.env['omniauth.auth'].extra.access_token.consumer.secret
    @user.access_token = request.env['omniauth.auth'].extra.access_token.token
    @user.access_token_secret = request.env['omniauth.auth'].extra.access_token.secret
    check_persisted_and_redirect(@user, 'twitter')
  end

  def failure
    redirect_to root_path
  end

  private

  def check_persisted_and_redirect(user, provider)
    if user.persisted?
      sign_in_and_redirect user, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: provider.upcase_first) if is_navigational_format?
    else
      session["devise.#{provider}_data"] = request.env['omniauth.auth'].except('extra')
      redirect_to new_user_registration_url
    end
  end

  def fill_user_data(user, request)
    user.provider = request.env['omniauth.auth'].provider
    user.uid = request.env['omniauth.auth'].uid
    user.token = request.env['omniauth.auth'].credentials.token
    user
  end
end