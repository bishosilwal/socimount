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

  def page_feed(graph = page_graph)
    graph.get_connection("me","feed")
  end

  def self.page_post(message, page_graph = page_graph)
    page_graph.put_wall_post(message)
  end
end