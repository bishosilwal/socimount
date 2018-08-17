class KoalaService
  attr_accessor :user_token, :graph, :pages

  def initialize(token)
    @user_token = token
    @graph =  Koala::Facebook::API.new(@user_token)
    @pages = graph.get_connection("me","accounts")
  end

  def page_graph(access_token = @pages.second["access_token"])
    Koala::Facebook::API.new(access_token)
  end

  def page_graph_from_id(page_id)
    page_token = @graph.get_page_access_token(page_id)
    page_graph(page_token)
  end

  def page_feed(graph = page_graph)
    graph.get_connection("me","feed")
  end
 
  def self.page_post(params, koala)
    page_graph = koala.page_graph(params[:access_token])
    if params[:images].nil?
      page_graph.put_wall_post(params[:message])
    else
      images_hash = {}
      @image_ids = []
      params[:images].each do |file|
        fb_photo = page_graph.put_picture(file, 'image/jpeg', published: false)
        @image_ids << fb_photo["id"]
      end
      @image_ids.each_with_index{|id, index| images_hash["attached_media[#{index}]"] = "{media_fbid: #{id}}"}

      page_graph.put_connections('me', 'feed', images_hash.merge({'message'=> params[:message]}))
    end  
  end
end