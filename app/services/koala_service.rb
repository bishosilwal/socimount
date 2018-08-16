class KoalaService
  attr_accessor :user_token, :graph, :pages

  def initialize(token)
    @user_token = token
    @graph =  Koala::Facebook::API.new(@user_token)
    @pages = graph.get_connection("me","accounts")
  end

  def first_page_graph
    Koala::Facebook::API.new(@pages.first["access_token"])
  end

  def page_feed(graph=first_page_graph)
    graph.get_connection("me","feed")
  end

  def page_post(message, page_graph = first_page_graph)
    page_graph.put_wall_post(message)
  end
end