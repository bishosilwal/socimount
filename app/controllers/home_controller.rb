class HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :set_koala

  def index
    @pages = @koala.pages
    @page_posts = @koala.page_feed
  end

  def page_post
    # PagePostWorker.perform_in(params[:delay_time].to_time, post_params, @koala)
    KoalaService.page_post(post_params,@koala)
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
    @koala =  KoalaService.new(current_user.token)
  end

  def post_params
    params.permit(:access_token, :message, images: [])
  end
end
