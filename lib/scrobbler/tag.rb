# Below is code samples for how to find the top albums and tracks for a tag.
# 
#   tag = Scrobbler::Tag.new('country')
# 
#   puts 'Top Albums'
#   tag.top_albums.each { |a| puts "(#{a.count}) #{a.name} by #{a.artist}" }
# 
#   puts
# 
#   puts 'Top Tracks'
#   tag.top_tracks.each { |t| puts "(#{t.count}) #{t.name} by #{t.artist}" }
#   
# Which would output something similar to:
# 
#   Top Albums
#   (29) American IV: The Man Comes Around by Johnny Cash
#   (14) Folks Pop In at the Waterhouse by Various Artists
#   (13) Hapless by Flowers From The Man Who Shot Your Cousin
#   (9) Taking The Long Way by Dixie Chicks
#   (8) Unchained by Johnny Cash
#   (8) American III: Solitary Man by Johnny Cash
#   (8) Wide Open Spaces by Dixie Chicks
#   (7) It's Now or Later by Tangled Star
#   (7) Greatest Hits by Hank Williams
#   (7) American Recordings by Johnny Cash
#   (6) Forgotten Landscape by theNoLifeKing
#   (6) At Folsom Prison by Johnny Cash
#   (6) Fox Confessor Brings the Flood by Neko Case
#   (6) Murder by Johnny Cash
#   (5) Gloom by theNoLifeKing
#   (5) Set This Circus Down by Tim McGraw
#   (5) Blacklisted by Neko Case
#   (5) Breathe by Faith Hill
#   (5) Unearthed (disc 4: My Mother's Hymn Book) by Johnny Cash
#   (4) Home by Dixie Chicks
# 
#   Top Tracks
#   (221) Hurt by Johnny Cash
#   (152) I Walk the Line by Johnny Cash
#   (147) Ring of Fire by Johnny Cash
#   (125) Folsom Prison Blues by Johnny Cash
#   (77) The Man Comes Around by Johnny Cash
#   (67) Personal Jesus by Johnny Cash
#   (65) Not Ready To Make Nice by Dixie Chicks
#   (63) Before He Cheats by Carrie Underwood
#   (62) Give My Love to Rose by Johnny Cash
#   (49) Jackson by Johnny Cash
#   (49) What Hurts The Most by Rascal Flatts
#   (48) Big River by Johnny Cash
#   (46) Man in Black by Johnny Cash
#   (46) Jolene by Dolly Parton
#   (46) Friends in Low Places by Garth Brooks
#   (46) One by Johnny Cash
#   (44) Cocaine Blues by Johnny Cash
#   (41) Get Rhythm by Johnny Cash
#   (41) I Still Miss Someone by Johnny Cash
#   (40) The Devil Went Down to Georgia by Charlie Daniels Band
module Scrobbler
  class Tag < Base
    attr_accessor :name, :count, :url, :streamable
    
    class << self
      def new_from_libxml(xml)
        data = {}
        xml.children.each do |child|
          data[:name] = child.content if child.name == 'name'
          data[:count] = child.content.to_i if child.name == 'count'
          data[:url] = child.content if child.name == 'url'
          if child.name == 'streamable'
            if ['1', 'true'].include?(child.content)
              data[:streamable] = true
            else
              data[:streamable] = false
            end
          end
        end
        
        Tag.new(data[:name], data)
      end
    end
    
    def initialize(name, data={})
      raise ArgumentError, "Name is required" if name.blank?
      @name = name
      @url = data[:url] unless data[:url].nil?
      @count = data[:count] unless data[:count].nil?
      @streamable = data[:streamable] unless data[:streamable].nil?
    end
    
    def top_artists(force=false)
      get_response('tag.gettopartists', :top_artists, 'topartists', 'artist', {'tag'=>@name}, force)
    end
    
    def top_albums(force=false)
      get_response('tag.gettopalbums', :top_albums, 'topalbums', 'album', {'tag'=>@name}, force)
    end

    def top_tracks(force=false)
      get_response('tag.gettoptracks', :top_tracks, 'toptracks', 'track', {'tag'=>@name}, force)
    end

    def Tag.top_tags
        self.get('tag.gettoptags', :toptags, :tag)
    end
    
    # Search for tags similar to this one. Returns tags ranked by similarity, 
    # based on listening data.
    def similar(force=false)
        params = {:tag => @name}
        get_response('tag.getsimilar', :similar, 'similartags', 'tag', params, force)
    end
  end
end
