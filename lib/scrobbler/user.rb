# Probably the most common use of this lib would be to get your most recent tracks or your top tracks. Below are some code samples.
#   user = Scrobbler::User.new('jnunemaker')
#
#   puts "#{user.username}'s Recent Tracks"
#   puts "=" * (user.username.length + 16)
#   user.recent_tracks.each { |t| puts t.name }
#
#   puts
#   puts
#
#   puts "#{user.username}'s Top Tracks"
#   puts "=" * (user.username.length + 13)
#   user.top_tracks.each { |t| puts "(#{t.playcount}) #{t.name}" }
#
# Which would output something like:
#
#   jnunemaker's Recent Tracks
#   ==========================
#   Everything You Want
#   You're a God
#   Bitter Sweet Symphony [Original Version]
#   Lord I Guess I'll Never Know
#   Country Song
#   Bitter Sweet Symphony (Radio Edit)
#
#
#   jnunemaker's Top Tracks
#   =======================
#   (62) Probably Wouldn't Be This Way
#   (55) Not Ready To Make Nice
#   (45) Easy Silence
#   (43) Song 2
#   (40) Everybody Knows
#   (39) Before He Cheats
#   (39) Something's Gotta Give
#   (38) Hips Don't Lie (featuring Wyclef Jean)
#   (37) Unwritten
#   (37) Move Along
#   (37) Dance, Dance
#   (36) We Belong Together
#   (36) Jesus, Take the Wheel
#   (36) Black Horse and the Cherry Tree (radio version)
#   (35) Photograph
#   (35) You're Beautiful
#   (35) Walk Away
#   (34) Stickwitu
module Scrobbler
  class User < Base
    # Load Helper modules
    include ImageObjectFuncs
    extend  ImageClassFuncs

    attr_reader :username, :url, :weight, :match, :realname, :name

    class << self
      def new_from_libxml(xml)
        data = {}
        xml.children.each do |child|
          data[:name] = child.content if child.name == 'name'
          data[:url] = child.content if child.name == 'url'
          data[:weight] = child.content.to_i if child.name == 'weight'
          data[:match] = child.content if child.name == 'match'
          data[:realname] = child.content if child.name == 'realname'
          maybe_image_node(data, child)
        end
        User.new(data[:name], data)
      end

      def find(*args)
        options = {:include_profile => false}
        options.merge!(args.pop) if args.last.is_a?(Hash)
        users = args.flatten.inject([]) { |users, u| users << User.new(u, options); users }
        users.length == 1 ? users.pop : users
      end
    end

    def initialize(username, input={})
      data = {:include_profile => false}.merge(input)
      raise ArgumentError if username.blank?
      @username = username
      @name = @username
      load_profile() if data[:include_profile]
      populate_data(data)
    end

    # Get a list of upcoming events that this user is attending.
    #
    # Supports ical, ics or rss as its format
    def events(force=false)
      get_response('user.getevents', :events, 'events', 'event', {'user'=>@username}, force)
    end

    # Get a list of the user's friends on Last.fm.
    def friends(force=false, page=1, limit=50)
      get_response('user.getfriends', :friends, 'friends', 'user', {'user'=>@username, 'page'=>page.to_s, 'limit'=>limit.to_s}, force)
    end

    # Get information about a user profile.
    def load_info
      # This function requires authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

    # Get the last 50 tracks loved by a user.
    def loved_tracks(force=false, extra={})
      get_response('user.getlovedtracks', :loved_tracks, 'lovedtracks', 'track', {'user'=>@username}.merge(extra), force)
    end

    # Get a list of a user's neighbours on Last.fm.
    def neighbours(force=false)
      get_response('user.getneighbours', :neighbours, 'neighbours', 'user', {'user'=>@username}, force)
    end

    # Get a paginated list of all events a user has attended in the past.
    def past_events(format=:ics)
      # This needs a Event class, which is yet not available
      raise NotImplementedError
    end

    # Get a list of a user's playlists on Last.fm.
    def playlists(force=false)
      #(api_method, instance_name, parent, element, parameters, force=false)
      get_response('user.getplaylists', :playlist, 'playlists', 'playlist', {'user'=>@username}, force)
    end

    # Get a list of the recent tracks listened to by this user. Indicates now
    # playing track if the user is currently listening.
    #
    # Possible parameters:
    #   - limit: An integer used to limit the number of tracks returned.
    def recent_tracks(force=false, parameters={})
      parameters.merge!({'user' => @username})
      get_response('user.getrecenttracks', :recent_tracks, 'recenttracks', 'track', parameters, force)
    end

    # Get Last.fm artist recommendations for a user
    def recommended_artists
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

    # Get a paginated list of all events recommended to a user by Last.fm,
    # based on their listening profile.
    def recommended_events
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

    # Get shouts for this user.
    def shouts
      # This needs a Shout class which is yet not available
      raise NotImplementedError
    end

    # Get the top albums listened to by a user. You can stipulate a time period.
    # Sends the overall chart by default.
    def top_albums(force=false, period='overall')
      get_response('user.gettopalbums', :top_albums, 'topalbums', 'album', {'user'=>@username, 'period'=>period}, force)
    end

    # Get the top artists listened to by a user. You can stipulate a time
    # period. Sends the overall chart by default.
    def top_artists(force=false, period='overall')
      get_response('user.gettopartists', :top_artists, 'topartists', 'artist', {'user' => @username, 'period'=>period}, force)
    end

    #  Get the top tags used by this user.
    def top_tags(force=false)
      get_response('user.gettoptags', :top_tags, 'toptags', 'tag', {'user'=>@username}, force)
    end

    # Get the top tracks listened to by a user. You can stipulate a time period.
    # Sends the overall chart by default.
    def top_tracks(force=false, period='overall')
      get_response('user.gettoptracks', :top_tracks, 'toptracks', 'track', {'user'=>@username, 'period'=>period}, force)
    end

    # Get an album chart for a user profile, for a given date range. If no date
    # range is supplied, it will return the most recent album chart for this
    # user.
    def weekly_album_chart(from=nil, to=nil)
      parameters = {'user' => @username}
      parameters['from'] = from unless from.nil?
      parameters['to'] = to unless to.nil?
      get_response('user.getweeklyalbumchart', nil, 'weeklyalbumchart', 'album', parameters, true)
    end

    # Get an artist chart for a user profile, for a given date range. If no date
    # range is supplied, it will return the most recent artist chart for this
    # user.
    def weekly_artist_chart(from=nil, to=nil)
      parameters = {'user' => @username}
      parameters['from'] = from unless from.nil?
      parameters['to'] = to unless to.nil?
      get_response('user.getweeklyartistchart', nil, 'weeklyartistchart', 'artist', parameters, true)
    end

    # Get a list of available charts for this user, expressed as date ranges
    # which can be sent to the chart services.
    def weekly_chart_list(force=false)
      # @todo
      raise NotImplementedError
    end

    # Get a track chart for a user profile, for a given date range. If no date
    # range is supplied, it will return the most recent track chart for this
    # user.
    def weekly_track_chart(from=nil, to=nil)
      parameters = {'user' => @username}
      parameters['from'] = from unless from.nil?
      parameters['to'] = to unless to.nil?
      get_response('user.getweeklytrackchart', nil, 'weeklytrackchart', 'track', parameters, true)
    end

    # Shout on this user's shoutbox
    def shout(message)
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

  end
end
