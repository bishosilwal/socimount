class HomeController < ApplicationController
  before_action :authenticate_user!, except: [:set_email]
  before_action :set_koala, except: [:set_email]

  def index
    @facebook_pages = []
    @facebook_page_posts = []
    unless @koala.nil?
      @facebook_pages = @koala.pages
      @facebook_page_posts = @koala.page_feed
    end
    @twitter_page_posts = TwitterWrapper.new(current_user.id).get_timeline unless current_user.user_omniauths.find_by(provider: 'twitter').nil?
    @instagram_page_posts = @page_posts = InstagramWrapper.new(current_user.id).get_post unless current_user.user_omniauths.find_by(provider: 'instagram').nil?
    @connected_app = current_user.user_omniauths.pluck(:provider)
  end

  def page_post
    post = Post.create(message: post_params[:message], user: current_user)
    post_params[:images].each { |image| Image.create(image: image, post: post) } unless post_params[:images].nil?
    PagePostWorker.perform_in(post_params[:delay_time].to_time, post.id, post_params[:access_token], current_user.id)
    redirect_to :home_index
  end

  def page_filter
    @facebook_pages = @koala.pages
    @page_graph = @koala.page_graph_from_id(params[:page_id])
    @facebook_page_posts = @koala.page_feed(@page_graph)
    render :index
  end

  def set_email
    session['omniauth_data']['info']['email'] = params[:email]
    @user = User.from_omniauth(session['omniauth_data'])
    user_omniauth = @user.user_omniauths.find_by(provider: session['omniauth_data']['provider'])
    if user_omniauth
      user_omniauth.uid = session['omniauth_data']['uid']
      user_omniauth.token = session['omniauth_data']['credentials']['token']
      user_omniauth.save
    else
      @user.user_omniauths.create do |user_omniauth|
        user_omniauth.provider = session['omniauth_data']['provider']
        user_omniauth.uid = session['omniauth_data']['uid']
        user_omniauth.token = session['omniauth_data']['credentials']['token']
      end
    end
    sign_in_and_redirect @user, event: :authentication
  end

  private

  def set_koala
    user_omniauth = current_user.user_omniauths.find_by(provider: 'facebook')
    if user_omniauth
      @koala = KoalaWrapper.new(user_omniauth.token)
    end
  end

  def post_params
    params.permit(:access_token, :message, :delay_time, images: [])
  end
end
