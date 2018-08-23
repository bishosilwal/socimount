class TwitterWrapper
  attr_accessor :client

  def initialize(user)
    if(user.class == User)
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = user.consumer_key
        config.consumer_secret     = user.consumer_secret
        config.access_token        = user.access_token
        config.access_token_secret = user.access_token_secret
      end
    elsif(user.class == Hash) 
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = user['consumer_key']
        config.consumer_secret     = user['consumer_secret']
        config.access_token        = user['access_token']
        config.access_token_secret = user['access_token_secret']
      end
    end
  end

  def get_timeline
    @client.user_timeline
  end

  def post_timeline(post_id)
    post = Post.find(post_id)
    if post.images.empty?
      @client.update(post.message)
    else
      images = post.images.map { |img| img.image.path }
      @client.update_with_media(post.message, images)
    end
  end
end