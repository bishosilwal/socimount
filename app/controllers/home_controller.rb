class HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :set_koala

  def index
    @pages = @koala.pages
    @page_posts = @koala.page_feed
  end

  def page_post
    page_graph = @koala.page_graph(params[:access_token])
    KoalaService.page_post(params[:message], page_graph)
    redirect_to :home_index
  end

  private

  def set_koala
    @koala =  KoalaService.new(current_user.token)
  end
end
