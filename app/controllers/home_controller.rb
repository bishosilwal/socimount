class HomeController < ApplicationController
  before_action :authenticate_user!, except: [:set_email]
  before_action :set_wrapper, except: [:set_email]

  def index
    unless @facebook.nil?
      @facebook_pages = @facebook.pages
      if(params[:page_id])
        @page_graph = @facebook.page_graph_from_id(params[:page_id])
        @facebook_page_posts = @facebook.page_feed(@page_graph)
      else
        @facebook_page_posts = @facebook.page_feed
      end
    end
    @twitter_page_posts = @twitter.get_timeline unless @twitter.nil?
    @instagram_page_posts = @page_posts = @instagram.get_post unless @instagram.nil?
    @connected_app = current_user.providers
  end

  def page_post
    post = Post.create(message: post_params[:message], user: current_user)
    post_params[:images].each { |image| Image.create(image: image, post: post) } unless post_params[:images].nil?
    PagePostWorker.perform_in(post_params[:delay_time].to_time, post.id, current_user.id, worker_params.to_unsafe_h)
    redirect_to :home_index
  end

  def set_email
    session['omniauth_data']['info']['email'] = params[:email]
    @user = User.from_omniauth(session['omniauth_data'])
    user_omniauth = @user.social_app_by_provider(session['omniauth_data']['provider'])
    if user_omniauth
      user_omniauth.uid = session['omniauth_data']['uid']
      user_omniauth.token = session['omniauth_data']['credentials']['token']
      user_omniauth.status = :active
      user_omniauth.save
    else
      @user.user_omniauths.create do |user_omniauth|
        user_omniauth.provider = session['omniauth_data']['provider']
        user_omniauth.uid = session['omniauth_data']['uid']
        user_omniauth.token = session['omniauth_data']['credentials']['token']
        user_omniauth.status = :active
      end
    end
    sign_in_and_redirect @user, event: :authentication
  end

  def disconnect
    current_user.social_app(params[:provider]).update(status: :inactive)
    redirect_to :home_index
  end

  private

  def set_wrapper
    facebook = current_user.social_app('facebook')
    twitter = current_user.social_app('twitter')
    instagram = current_user.social_app('instagram')
    @facebook = KoalaWrapper.new(facebook.token) if facebook
    @twitter = TwitterWrapper.new(current_user.id) if twitter
    @instagram = InstagramWrapper.new(current_user.id) if instagram
  end

  def post_params
    params.permit(:message, :delay_time, images: [])
  end

  def worker_params
    params.permit(:twitter, :facebook, :access_token)
  end
end
