class HomeController < ApplicationController
  before_action :authenticate_user!, except: [:set_email]
  before_action :set_koala, except: [:set_email]

  def index
    binding.pry
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

  def set_email
    session['omniauth_data']['info']['email'] = params[:email]
    @user = User.from_omniauth(session['omniauth_data'])
    @user.provider = session['omniauth_data']['provider']
    @user.uid = session['omniauth_data']['uid']
    @user.token = session['omniauth_data']['credentials']['token']
    @user.save
    sign_in_and_redirect @user, event: :authentication
  end

  private

  def set_koala
    @koala = KoalaWrapper.new(current_user.token) if current_user.provider == 'facebook'
  end

  def post_params
    params.permit(:access_token, :message, :delay_time, images: [])
  end
end
