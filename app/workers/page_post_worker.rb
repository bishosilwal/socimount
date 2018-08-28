class PagePostWorker
  include Sidekiq::Worker

  def perform(post_id, page_token, user_id)
    user = User.find(user_id)
    case user['provider']
    when 'facebook'
      KoalaWrapper.page_post(post_id, page_token, user.token)
    when 'twitter'
      TwitterWrapper.new(user_id).post_timeline(post_id)
    end
  end
end
