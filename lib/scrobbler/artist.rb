# Below are examples of how to find an artists top tracks and similar artists.
# 
#   artist = Scrobbler::Artist.new('Carrie Underwood')
# 
#   puts 'Top Tracks'
#   puts "=" * 10
#   artist.top_tracks.each { |t| puts "(#{t.reach}) #{t.name}" }
# 
#   puts
# 
#   puts 'Similar Artists'
#   puts "=" * 15
#   artist.similar.each { |a| puts "(#{a.match}%) #{a.name}" }
# 
# Would output something similar to:
# 
#   Top Tracks
#   ==========
#   (8797) Before He Cheats
#   (3574) Don't Forget to Remember Me
#   (3569) Wasted
#   (3246) Some Hearts
#   (3142) Jesus, Take the Wheel
#   (2600) Starts With Goodbye
#   (2511) Jesus Take The Wheel
#   (2423) Inside Your Heaven
#   (2328) Lessons Learned
#   (2040) I Just Can't Live a Lie
#   (1899) Whenever You Remember
#   (1882) We're Young and Beautiful
#   (1854) That's Where It Is
#   (1786) I Ain't in Checotah Anymore
#   (1596) The Night Before (Life Goes On)
#   
#   Similar Artists
#   ===============
#   (100%) Rascal Flatts
#   (84.985%) Keith Urban
#   (84.007%) Kellie Pickler
#   (82.694%) Katharine McPhee
#   (81.213%) Martina McBride
#   (79.397%) Faith Hill
#   (77.121%) Tim McGraw
#   (75.191%) Jessica Simpson
#   (75.182%) Sara Evans
#   (75.144%) The Wreckers
#   (73.034%) Kenny Chesney
#   (71.765%) Dixie Chicks
#   (71.084%) Kelly Clarkson
#   (69.535%) Miranda Lambert
#   (66.952%) LeAnn Rimes
#   (66.398%) Mandy Moore
#   (65.817%) Bo Bice
#   (65.279%) Diana DeGarmo
#   (65.115%) Gretchen Wilson
#   (62.982%) Clay Aiken
#   (62.436%) Ashlee Simpson
#   (62.160%) Christina Aguilera
module Scrobbler
  # @todo Add missing functions that require authentication
  # @todo Integrate search functionality into this class which is already implemented in Scrobbler::Search
  class Artist < Base
    mixins :image, :streamable
    
    attr_accessor :name, :mbid, :playcount, :rank, :url, :count
    attr_accessor :chartposition
    attr_accessor :match, :tagcount, :listeners
    
    class << self
      def new_from_libxml(xml)
        data = {}
      
        # Get all information from the root's children nodes
        xml.children.each do |child|
          data[:playcount] = child.content.to_i if child.name == 'playcount'
          data[:mbid] = child.content if child.name == 'mbid'
          data[:url] = child.content if child.name == 'url'
          data[:match] = child.content.to_i if child.name == 'match'
          data[:tagcount] = child.content.to_i if child.name == 'tagcount'
          data[:chartposition] = child.content if child.name == 'chartposition'
          data[:name] = child.content if child.name == 'name'
          maybe_streamable_node(data, child)
          maybe_image_node(data, child)
        end        
        
        # If we have not found anything in the content of this node yet then
        # this must be a simple artist node which has the name of the artist
        # as its content
        data[:name] = xml.content if data == {}
        
        # Get all information from the root's attributes
        data[:name] = xml['name'] if xml['name']
        data[:rank] = xml['rank'].to_i if xml['rank']
        maybe_streamable_attribute data, xml
        data[:mbid] = xml['mbid'] if xml['mbid']
        
        # Step 3 fill the object
        Artist.new(data[:name], data)
      end
    end
    
    def initialize(name, data = {})
      super()
      raise ArgumentError, "Name is required" if name.blank?
      @name = name
      populate_data(data)
    end
    
    # Get the URL to the ical or rss representation of the current events that
    # a artist will play
    #
    # @todo Use the API function and parse that into a common ruby structure
    def current_events(format=:ics)
      format = :ics if format.to_s == 'ical'
      raise ArgumentError unless ['ics', 'rss'].include?(format.to_s)
      "#{API_URL.chop}/2.0/artist/#{CGI::escape(@name)}/events.#{format}"
    end
    
    def similar(force=false)
      get_response('artist.getsimilar', :similar, 'similarartists', 'artist', {'artist' => @name}, force)
    end
    
    def top_fans(force=false)
      get_response('artist.gettopfans', :top_fans, 'topfans', 'user', {'artist' => @name}, force)
    end
    
    def top_tracks(force=false)
      get_response('artist.gettoptracks', :top_tracks, 'toptracks', 'track', {'artist'=>@name}, force)
    end
    
    def top_albums(force=false)
      get_response('artist.gettopalbums', :top_albums, 'topalbums', 'album', {'artist'=>@name}, force)
    end
    
    def top_tags(force=false)
      get_response('artist.gettoptags', :top_tags, 'toptags', 'tag', {'artist' => @name}, force)
    end
    
    @info_loaded = false
    # Get the metadata
    def load_info
        doc = Base.request('artist.getinfo', {'artist' => @name})
        doc.root.children.each do |childL1|
            next unless childL1.name == 'artist'
            childL1.children.each do |child|
                @mbid = child.content if child.name == 'mbid'
                @url = child.content if child.name == 'url'
                check_image_node child
                check_streamable_node child
                if child.name == 'stats'
                    child.children.each do |childL3|
                        @listeners = childL3.content.to_i if childL3.name == 'listeners'
                        @playcount = childL3.content.to_i if childL3.name == 'playcount'
                    end
                end
            end
        end
        @info_loaded = true
    end # load_info
    
    def ==(otherArtist)
      if otherArtist.is_a?(Scrobbler::Artist)
        return (@name == otherArtist.name)
      end
      false
    end
    
  end
end
