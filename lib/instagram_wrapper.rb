class InstagramWrapper
  attr_accessor :client

  def initialize(user)
    @client = InstagramApi.config do |config|
      config.access_token = user.token
      config.client_id = ENV['INSTAGRAM_APP_ID']
      config.client_secret = ENV['INSTAGRAM_APP_SECRET']
    end
  end

  def get_post
    InstagramApi.user.recent_media
  end
end