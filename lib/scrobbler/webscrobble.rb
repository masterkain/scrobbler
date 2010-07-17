#--
# Copyright (c) 2010 iCoreTech Labs.
#
# This file is part of the AudioBox.fm project.
#++

# Author::    Claudio Poli (mailto:claudio@icoretech.org)
# Copyright:: Copyright (c) 2010 iCoreTech Labs
# License::   iCoreTech Labs Private License

# current_user = User.find(2)
# scrobble = Scrobbler::WebScrobble.new(:user => current_user.profile.last_fm_username, :session_key => current_user.profile.last_fm_session_key)
# scrobble.handshake!
# scrobble.now_playing(current_user.tracks.first)

# scrobble.status
# scrobble.session_id
# scrobble.now_playing_url
# scrobble.submission_url

require 'digest/md5'

class HandshakeError < StandardError; end
class HandshakeBannedError < HandshakeError; end
class HandshakeBadAuthError < HandshakeError; end
class HandshakeBadTimeError < HandshakeError; end
class HandshakeRequestFailedError < HandshakeError; end
class HandshakeHardFailureError < HandshakeError; end

class NowPlayingError < StandardError; end
class NowPlayingBadSessionError < NowPlayingError; end
class NowPlayingHardFailureError < NowPlayingError; end

class ScrobbleError < StandardError; end
class ScrobbleBadSessionError < ScrobbleError; end
class ScrobbleRequestFailedError < ScrobbleError; end
class ScrobbleHardFailureError < ScrobbleError; end

module Scrobbler
  SUB_HOST = 'http://post.audioscrobbler.com:80'
  SUB_VER  = '1.2.1'

  class WebScrobble
    attr_accessor :user, :client_id, :client_ver
    attr_reader :status, :session_id, :now_playing_url, :submission_url

    def initialize(args = {})
      @secret_key  = App::Lastfm.secret_key
      @api_key     = App::Lastfm.api_key
      @client_id   = App::Lastfm.client_id
      @client_ver  = AUDIOBOX_VERSION
      @user        = args[:user]
      @session_key = args[:session_key]

      raise(ArgumentError, 'Missing required :user argument') if @user.blank?
      raise(ArgumentError, 'Missing required :session_key argument') if @session_key.blank?
    end

    # The initial negotiation with the submissions server to establish
    # authentication and connection details for the session.
    # IMPORTANT: the handshake must occur each time a client is started, and
    # additionally if failures are encountered later on in the submission process.
    def handshake!
      timestamp  = Time.now.to_i.to_s
      # Authentication Token for Web Services Authentication.
      auth_token = Digest::MD5.hexdigest(@secret_key + timestamp)

      query = {
        :hs      => 'true',      # Indicates that a handshake is requested.
        :p       => SUB_VER,     # Is the version of the submissions protocol to which the client conforms.
        :c       => @client_id,  # Is an identifier for the client.
        :v       => @client_ver, # Is the version of the client being used.
        :u       => @user,       # Is the name of the user.
        :t       => timestamp,   # Is a UNIX Timestamp representing the current time at which the request is being performed.
        :a       => auth_token,  # Is the authentication token. NOTE: generated with a different algorithm for web services.
        :api_key => @api_key,    # The API key from your Web Services account.
        :sk      => @session_key # The Web Services session key generated via the authentication protocol.
      }
      # Build the connection.
      connection = REST::Connection.new(SUB_HOST)
      result = connection.get('/', query)

      # The client should consider the first line of the response to determine
      # the action it should take as follows.
      @status = result.split(/\n/)[0]
      case @status
        when /OK/
          # This indicates that the handshake was successful.
          # Three lines will follow the OK response.
          @session_id, @now_playing_url, @submission_url = result.split(/\n/)[1,3]
        when /BANNED/
          # This indicates that this client version has been banned from the server.
          raise(HandshakeBannedError, "Handshake failed, user '#{@user}' is banned")
        when /BADAUTH/
          # This indicates that the authentication details provided were incorrect.
          # The client should not retry the handshake until the user has changed their details.
          raise(HandshakeBadAuthError, "Handshake failed, invalid authentication credentials for user '#{@user}'")
        when /BADTIME/
          # The timestamp provided was not close enough to the current time.
          # The system clock must be corrected before re-handshaking.
          raise(HandshakeBadTimeError, "Handshake failed, system clock not in sync")
        when /FAILED/
          # This indicates a temporary server failure.
          raise(HandshakeRequestFailedError, "Handshake failed, reason: '#{@status}'")
        else
          raise(HandshakeHardFailureError, "Handshake failed, reason unknown #{@status}")
      end
    end # end handshake!

    # The Now-Playing notification is a lightweight mechanism for notifying
    # Last.fm that a track has started playing. This is used for realtime
    # display of a user's currently playing track, and does not affect a user's
    # musical profile.
    def now_playing(track)
      track_album_name = (track.album.name.blank? || track.album.name == 'Unknown') ? '' : track.album.name
      track_number     = (track.track_number == 0) ? '' : track.track_number

      query = {
        :s => @session_id,               # The Session ID string returned by the handshake request. Required.
        :a => track.artist.name,         # The artist name. Required.
        :t => track.title,               # The track name. Required.
        :b => track_album_name,          # The album title, or an empty string if not known.
        :l => track.duration_in_seconds, # The length of the track in seconds, or an empty string if not known.
        :n => track.track_number,        # The position of the track on the album, or an empty string if not known.
        :m => '',                        # The MusicBrainz Track ID, or an empty string if not known.
      }
      # Build the connection.
      connection = REST::Connection.new(@now_playing_url)
      result = connection.post('', query)

      # The body of the server response will consist of a single \n (ASCII 10)
      # terminated line. The client should process the first line of the body
      # to determine the action it should take.
      @status = result.split(/\n/)[0]
      case @status
        when /OK/
          # Now playing submitted succesfully.
          true
        when /BADSESSION/
          raise(NowPlayingBadSessionError, "Now playing notification failed due to bad session")
        else
          raise(NowPlayingHardFailureError, "Now playing notification failed for unknown reason")
      end
    end # end now_playing

    def scrobble(tracks)
      tracks = tracks.is_a?(Array) ? tracks : [tracks]
      query = {
        :s => @session_id # The Session ID string returned by the handshake request. Required.
      }
      tracks.each_with_index do |track, i|
        if track.duration_in_seconds > 30
          track_album_name = (track.album.name.blank? || track.album.name == 'Unknown') ? '' : track.album.name
          track_number     = (track.track_number == 0) ? '' : track.track_number
          query["a[#{i}]".to_sym] = track.artist.name         # The artist name. Required.
          query["t[#{i}]".to_sym] = track.title               # The track title. Required.
          query["i[#{i}]".to_sym] = Time.now.utc.to_i.to_s    # The time the track started playing, in UNIX timestamp format.
          query["o[#{i}]".to_sym] = 'P'                       # The source of the track. Required.
          query["r[#{i}]".to_sym] = ''                        # A single character denoting the rating of the track. Empty if not applicable.
          query["l[#{i}]".to_sym] = track.duration_in_seconds # he length of the track in seconds. Required when the source is P, optional otherwise.
          query["b[#{i}]".to_sym] = track_album_name          # The album title, or an empty string if not known.
          query["n[#{i}]".to_sym] = track_number              # The position of the track on the album, or an empty string if not known.
          query["m[#{i}]".to_sym] = ''                        # The MusicBrainz Track ID, or an empty string if not known.
        end
      end

      # Build the connection.
      connection = REST::Connection.new(@submission_url)
      result = connection.post('', query)

      # The body of the server response will consist of a single \n (ASCII 10)
      # terminated line. The client should process the first line of the body
      # to determine the action it should take.
      @status = result.split(/\n/)[0]
      case @status
        when /OK/
          # Now playing submitted succesfully.
          @status
        when /BADSESSION/
          raise(ScrobbleBadSessionError, "Scrobble submission failed due to bad session")
        when /FAILED/
          # This indicates a temporary server failure.
          raise(ScrobbleRequestFailedError, "Scrobble submission failed, reason: '#{@status}'")
        else
          raise(ScrobbleHardFailureError, "Scrobble submission failed, reason unknown")
      end
    end

  end # end class WebScrobble

end # end module Scrobbler
