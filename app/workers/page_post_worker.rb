class PagePostWorker
  include Sidekiq::Worker

  def perform(post_params, koala)
    KoalaService.page_post(post_params, koala)
  end
end
