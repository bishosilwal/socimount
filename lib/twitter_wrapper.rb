class TwitterWrapper
  attr_accessor :client

  def initialize(user_id)
    user_omniauth = User.find(user_id).user_omniauths.find_by(provider: 'twitter')
    @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = user_omniauth.consumer_key
        config.consumer_secret     = user_omniauth.consumer_secret
        config.access_token        = user_omniauth.access_token
        config.access_token_secret = user_omniauth.access_token_secret
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