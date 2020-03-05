class KoalaWrapper
  attr_accessor :graph, :pages

  def initialize(token)
    @graph = Koala::Facebook::API.new(token)
    @pages = @graph.get_connection('me', 'accounts')
  end

  def page_graph(access_token = @pages.second['access_token'])
    Koala::Facebook::API.new(access_token)
  end

  def page_graph_from_id(page_id)
    page_token = @graph.get_page_access_token(page_id)
    page_graph(page_token)
  end

  def page_feed(graph = page_graph)
    posts = graph.get_connection('me', 'feed')
    posts.each_with_index do |post, index|
      post_summary = graph.get_object(post['id'], fields: 'likes.summary(true),attachments,comments.summary(true)')
      if post_summary['attachments']
        post_summary['attachments']['data'].each_with_index do |attachment, index1|
          if attachment['subattachments']
            attachment['subattachments']['data'].each_with_index do |subattachment, index2|
              if posts[index]['image'].nil?
                posts[index]['image'] = [subattachment['media']['image']['src']]
              else
                posts[index]['image'] << subattachment['media']['image']['src']
              end
            end
          else
            if posts[index]['image'].nil?
              posts[index]['image'] = [attachment['media']['image']['src']]
            else
              posts[index]['image'] << attachment['media']['image']['src']
            end
          end  
        end
      end
      posts[index]['likes'] = post_summary['likes']['summary']['total_count']
      posts[index]['comments'] = post_summary['comments']['data']
    end
  end

  def self.page_post(post_id, page_token, user_token)
    post = Post.find(post_id)
    koala = KoalaWrapper.new(user_token)
    page_graph = koala.page_graph(page_token)
    page_graph.put_wall_post(post.message)
    images_hash = {}
    @image_ids = []
    post.images.each do |file|
      fb_photo = page_graph.put_picture(file.image.path, file.image.content_type, published: false)
      @image_ids << fb_photo['id']
    end
    @image_ids.each_with_index { |id, index| images_hash["attached_media[#{index}]"] = "{media_fbid: #{id}}" }

    page_graph.put_connections('me', 'feed', images_hash.merge({ 'message' => post.message }))
  end
end