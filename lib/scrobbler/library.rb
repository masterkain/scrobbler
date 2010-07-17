module Scrobbler
  # @todo everything
  class Library < Base
    attr_reader :user
  
    def initialize(user)
      @user = user if user.class == Scrobbler::User
      @user = Scrobbler::User.new(user.to_s) unless user.class == Scrobbler::User
    end
    
    def add_album
        # This function require authentication, but SimpleAuth is not yet 2.0
        raise NotImplementedError
    end
    
    def add_artist
        # This function require authentication, but SimpleAuth is not yet 2.0
        raise NotImplementedError
    end
    
    def add_track
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end
    
    # A list of all the albums in a user's library, with play counts and tag 
    # counts. 
    def albums(options={})
        options = {:force => false, :all => true}.merge options
        options[:user] = @user.name
        albums = []
        if options[:all]
            doc = Base.request('library.getalbums', options)
            root = nil
            doc.root.children.each do |child|
                next unless child.name == 'albums'
                root = child
            end
            total_pages = root['totalPages'].to_i
            root.children.each do |child|
                next unless child.name == 'album'
                albums << Scrobbler::Album.new_from_libxml(child)
            end
            for i in 2..total_pages do
                options[:page] = i
                albums.concat get_response('library.getalbums', :none, 'albums', 'album', options, true)
            end
        else
            albums = get_response('library.getalbums', :get_albums, 'albums', 'album', options, true)
        end
        albums
    end

    # A list of all the artists in a user's library, with play counts and tag
    # counts. 
    def artists(options={})
        options = {:force => false, :all => true}.merge options
        options[:user] = @user.name
        artists = []
        if options[:all]
            doc = Base.request('library.getartists', options)
            root = nil
            doc.root.children.each do |child|
                next unless child.name == 'artists'
                root = child
            end
            total_pages = root['totalPages'].to_i
            root.children.each do |child|
                next unless child.name == 'artist'
                artists << Scrobbler::Artist.new_from_libxml(child)
            end
            for i in 2..total_pages do
                options[:page] = i
                artists.concat get_response('library.getartists', :none, 'artists', 'artist', options, true)
            end
        else
            artists = get_response('library.getartists', :get_albums, 'artists', 'artist', options, true)
        end
        artists
    end
    
    # A list of all the tracks in a user's library, with play counts and tag
    # counts. 
    def tracks(options={})
        options = {:force => false, :all => true}.merge options
        options[:user] = @user.name
        tracks = []
        if options[:all]
            doc = Base.request('library.gettracks', options)
            root = nil
            doc.root.children.each do |child|
                next unless child.name == 'tracks'
                root = child
            end
            total_pages = root['totalPages'].to_i
            root.children.each do |child|
                next unless child.name == 'track'
                tracks << Scrobbler::Track.new_from_libxml(child)
            end
            for i in 2..total_pages do
                options[:page] = i
                tracks.concat get_response('library.gettracks', :none, 'tracks', 'track', options, true)
            end
        else
            tracks = get_response('library.gettracks', :get_albums, 'tracks', 'track', options, true)
        end
        tracks
    end
    
  end
end

