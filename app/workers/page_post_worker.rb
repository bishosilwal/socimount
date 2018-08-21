class PagePostWorker
  include Sidekiq::Worker

  def perform(post_id, page_token, user_token)
    KoalaWrapper.page_post(post_id, page_token, user_token)
  end
end
