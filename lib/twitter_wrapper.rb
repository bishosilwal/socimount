class TwitterWrapper
  attr_accessor :client
  def initialize(user)
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = user.consumer_key
      config.consumer_secret     = user.consumer_secret
      config.access_token        = user.access_token
      config.access_token_secret = user.access_token_secret
    end
  end

  def get_timeline
    @client.user_timeline
  end
end