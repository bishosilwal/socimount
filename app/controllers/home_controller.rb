class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @page_posts = KoalaService.new(current_user.token).page_feed
  end

  def page_post
    KoalaService.new(current_user.token).page_post(params[:message])
    redirect_to :home_index

  end
end
