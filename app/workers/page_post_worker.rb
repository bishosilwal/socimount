class PagePostWorker
  include Sidekiq::Worker

  def perform(post_id, user_id, worker_params)
    worker_params = OpenStruct.new(worker_params)
    facebook = User.find(user_id).social_app('facebook')
    TwitterWrapper.new(user_id).post_timeline(post_id) if worker_params.twitter
    KoalaWrapper.page_post(post_id, worker_params.access_token, facebook.token) if worker_params.facebook
  end
end
