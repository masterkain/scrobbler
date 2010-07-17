module Scrobbler
  # @todo everything
  class Playlist < Base
    # Load Helper modules
    include ImageObjectFuncs
    extend  ImageClassFuncs
    
    attr_reader :url, :id, :title, :date, :creator
    attr_reader :description, :size, :duration, :streamable
    class << self
      def new_from_libxml(xml)
        data = {}

        xml.children.each do |child|
          data[:id] = child.content.to_i if child.name == 'id'
          data[:title] = child.content if child.name == 'title'

          maybe_image_node(data, child)
          data[:date] = Time.parse(child.content) if child.name == 'date'

          data[:size] = child.content.to_i if child.name == 'size'
          data[:description] = child.content if child.name == 'description'
          data[:duration] = child.content.to_i if child.name == 'duration'

          if child.name == 'streamable'
            if ['1', 'true'].include?(child.content)
              data[:streamable] = true
            else
              data[:streamable] = false
            end
          end
          data[:creator]        = child.content if child.name == 'creator'
          data[:url]        = child.content if child.name == 'url'
        end
        Playlist.new(data[:url],data)
      end
    end
  
    def initialize(url,data={})
      @url = url
      populate_data(data)
    end
  end
end

