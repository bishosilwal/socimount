class PagePostWorker
  include Sidekiq::Worker

  def perform(post_id, page_token, user_token)
    KoalaService.page_post(post_id, page_token, user_token)
  end
end
