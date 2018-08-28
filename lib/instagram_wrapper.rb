class InstagramWrapper
  attr_accessor :client

  def initialize(user_id)
    user_omniauth = User.find(user_id).social_app('instagram')
    @client = InstagramApi.config do |config|
      config.access_token = user_omniauth.token
      config.client_id = ENV['INSTAGRAM_APP_ID']
      config.client_secret = ENV['INSTAGRAM_APP_SECRET']
    end
  end

  def get_post
    InstagramApi.user.recent_media
  end
end