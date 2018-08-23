class HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :set_koala

  def index
    @pages = []
    @page_posts = []
    unless @koala.nil?
      @pages = @koala.pages
      @page_posts = @koala.page_feed
    end
    if current_user.provider == 'twitter'
      @page_posts = TwitterWrapper.new(current_user).get_timeline
    end
  end

  def page_post
    post = Post.create(message: post_params[:message], user: current_user)
    post_params[:images].each { |image| Image.create(image: image, post: post) } unless post_params[:images].nil?
    PagePostWorker.perform_in(post_params[:delay_time].to_time, post.id, post_params[:access_token], current_user.id)
    redirect_to :home_index
  end

  def page_filter
    @pages = @koala.pages
    @page_graph = @koala.page_graph_from_id(params[:page_id])
    @page_posts = @koala.page_feed(@page_graph)
    render :index
  end

  private

  def set_koala
    @koala = KoalaWrapper.new(current_user.token) unless current_user.provider != 'facebook'
  end

  def post_params
    params.permit(:access_token, :message, :delay_time, images: [])
  end
end
