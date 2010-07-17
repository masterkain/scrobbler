# Getting information about an album such as release date and the tracks on it is very easy.
# 
#   album = Scrobbler::Album.new('Carrie Underwood', 'Some Hearts', :include_info => true)
# 
#   puts "Album: #{album.name}"
#   puts "Artist: #{album.artist}"
#   puts "Reach: #{album.reach}"
#   puts "URL: #{album.url}"
#   puts "Release Date: #{album.release_date.strftime('%m/%d/%Y')}"
# 
#   puts
#   puts
# 
#   puts "Tracks"
#   longest_track_name = album.tracks.collect(&:name).sort { |x, y| y.length <=> x.length }.first.length
#   puts "=" * longest_track_name
#   album.tracks.each { |t| puts t.name }
#
# Would output:
#
#   Album: Some Hearts
#   Artist: Carrie Underwood
#   Reach: 18729
#   URL: http://www.last.fm/music/Carrie+Underwood/Some+Hearts
#   Release Date: 11/15/2005
# 
# 
#   Tracks
#   ===============================
#   Wasted
#   Don't Forget to Remember Me
#   Some Hearts
#   Jesus, Take the Wheel
#   The Night Before (Life Goes On)
#   Lessons Learned
#   Before He Cheats
#   Starts With Goodbye
#   I Just Can't Live a Lie
#   We're Young and Beautiful
#   That's Where It Is
#   Whenever You Remember
#   I Ain't in Checotah Anymore
#   Inside Your Heaven
#
module Scrobbler
  # @todo Add missing functions that require authentication
  class Album < Base
    mixins :image
    
    attr_reader :artist, :artist_mbid, :name, :mbid, :playcount, :rank, :url
    attr_reader :reach, :release_date, :listeners, :playcount, :top_tags
    attr_reader :image_large, :image_medium, :image_small, :tagcount, :image_extralarge
    
    # needed on top albums for tag
    attr_reader :count
    
    # needed for weekly album charts
    attr_reader :chartposition, :position
    
    class << self
      def new_from_libxml(xml)
        data = {}

        xml.children.each do |child|
          data[:name] = child.content if ['name', 'title'].include?(child.name)
          data[:playcount] = child.content.to_i if child.name == 'playcount'
          data[:tagcount] = child.content.to_i if child.name == 'tagcount'
          data[:mbid] = child.content if child.name == 'mbid'
          data[:url] = child.content if child.name == 'url'
          data[:artist] = Artist.new_from_libxml(child) if child.name == 'artist'
          maybe_image_node(data, child)
        end
        
        # If we have not found anything in the content of this node yet then
        # this must be a simple artist node which has the name of the artist
        # as its content
        data[:name] = xml.content if data == {}
        
        # Get all information from the root's attributes
        data[:mbid] = xml['mbid'] if xml['mbid']
        data[:rank] = xml['rank'].to_i if xml['rank']
        data[:position] = xml['position'].to_i if xml['position']
        
        # If there is no name defined, than this was an empty album tag
        return nil if data[:name].empty?
        
        Album.new(data[:name], data)
      end
    end
      
    # If the additional parameter :include_info is set to true, additional 
    # information is loaded
    #
    # @todo Albums should be able to be created via a MusicBrainz id too
    def initialize(name, input={})
      super()      
      # Support old version of initialize where we had (artist_name, album_name)
      if input.class == String
        data = {:artist => name, :name => input}
        name = input, input = data
      end
      data = {:include_profile => false}.merge(input)
      raise ArgumentError, "Artist or mbid is required" if data[:artist].nil? && data[:mbid].nil?
      raise ArgumentError, "Name is required" if name.blank?
      @name = name
      populate_data(data)
      load_info() if data[:include_info]
    end
    
    # Indicates if the info was already loaded
    @info_loaded = false 
    
    # Load additional information about this album
    #
    # Calls "album.getinfo" REST method
    #
    # @todo Parse wiki content
    # @todo Add language code for wiki translation
    def load_info
      return nil if @info_loaded
      xml = Base.request('album.getinfo', {'artist' => @artist, 'album' => @name})
      unless xml.root['status'] == 'failed'
        xml.root.children.each do |childL1|
          next unless childL1.name == 'album'
          
          childL1.children.each do |childL2|
            @url = childL2.content if childL2.name == 'url'
            @id = childL2.content if childL2.name == 'id'
            @mbid = childL2.content if childL2.name == 'mbid'
            @release_date = Time.parse(childL2.content.strip) if childL2.name == 'releasedate'
            check_image_node childL2
            @listeners = childL2.content.to_i if childL2.name == 'listeners'
            @playcount = childL2.content.to_i if childL2.name == 'playcount'
            if childL2.name == 'toptags'
              @top_tags = []
              childL2.children.each do |childL3|
                next unless childL3.name == 'tag'
                @top_tags << Tag.new_from_libxml(childL3)
              end # childL2.children.each do |childL3|
            end # if childL2.name == 'toptags'
          end # childL1.children.each do |childL2|
        end # xml.children.each do |childL1|
        @info_loaded  = true
      end
    end
    
    # Tag an album using a list of user supplied tags. 
    def add_tags(tags)
        # This function require authentication, but SimpleAuth is not yet 2.0
        raise NotImplementedError
    end

    # Get the tags applied by an individual user to an album on Last.fm.
    def tags()
        # This function require authentication, but SimpleAuth is not yet 2.0
        raise NotImplementedError
    end

    # Remove a user's tag from an album.
    def remove_tag()
        # This function require authentication, but SimpleAuth is not yet 2.0
        raise NotImplementedError
    end
  end
end
