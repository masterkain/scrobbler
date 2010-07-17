# exception definitions
class BadAuthError < StandardError; end
class BadSessionError < StandardError; end
class BadTimeError < StandardError; end
class ClientBannedError < StandardError; end
class RequestFailedError < StandardError; end

module Scrobbler
  class Scrobble
    SUBMISSION_HOST = 'http://post.audioscrobbler.com:80/'
    SUBMISSION_PORT = 80
    SUBMISSION_VERSION = '1.2.1'
    
    @@client_id = 'tst'
    @@client_ver = '1.0'
    @@default_options = {
      :handshake_on_init => true
    }

    def Scrobble.client_id=(cid)
      @@client_id = cid
    end
    
    def Scrobble.client_ver=(cver)
      @@client_ver = cver
    end
    
    def initialize(options={})
      params = @@default_options.merge(options)
      warn 'Warning: Default client id used, this is for testing only' if @@client_id == 'tst'
      raise ArgumentError, 'Session is required' if params[:session].nil?
      raise ArgumentError, 'User is required' if params[:user].nil?
      @session = params[:session]
      @user = params[:user]
    end
    
    def handshake
      ts = Time.now.to_i.to_s
      auth_token = Digest::MD5.hexdigest(@session.key + ts)
      params = {
        :hs => 'true',
        :ps => SUBMISSION_VERSION,
        :c => @@client_id,
        :v => @@client_ver,
        :u => @user.name,
        :t => ts,
        :a => auth_token,
        :sk => @session.key
      }
      url = URI.join(SUBMISSION_HOST)
      query = []
      params.each do |k,v|
        query << [Base.sanitize(k), Base.sanitize(v)]
      end
      url.query = query.join('&')
      req = Net::HTTP::Get.new(url.request_uri)
      res = Net::HTTP.start(SUBMISSION_HOST, SUBMISSION_PORT) do |conn|
        conn.request(req)
      end
      res = res.body.split("\n")
      if res[0] == 'OK'
        # Handshake done, parse and return information
        @session_id = res[1]
        @now_playing_url = res[2]
        @submission_url = res[3]
      elsif res[0] == 'BANNED'
        # This indicates that this client version has been banned from the
        # server. This usually happens if the client is violating the protocol
        # in a destructive way. Users should be asked to upgrade their client
        # application.
        raise ClientBannedError, 'Please update your client to a newer version.'
      elsif res[0] == 'BADAUTH'
        # This indicates that the authentication details provided were incorrect. 
        # The client should not retry the handshake until the user has changed 
        # their details
        raise BadAuthError
      elsif res[0] == 'BADTIME'
        # The timestamp provided was not close enough to the current time. 
        # The system clock must be corrected before re-handshaking.
        raise BadTimeError, "Not close enough to current time: #{ts}"
      else
        # This indicates a temporary server failure. The reason indicates the
        # cause of the failure. The client should proceed as directed in the
        # failure handling section
        raise RequestFailedError, res[0]
      end
    end #^ handshake
    
    def now_playing(track)
      params = {
        's' => @session_id,
        't' => track.name,
        'a' => track.artist.name,
        'b' => '',
        'l' => '',
        'n' => '',
        'm' => ''
      }
      params['b'] = track.album.name unless track.album.nil?
      params['l'] = track.duration.to_s unless track.duration.nil? && track.duration > 30
      # @todo params['n']
      params['m'] = track.mbid unless track.mbid.nil?
      res = Net::HTTP.post_form(URI.parse(SUBMISSION_HOST), params).body.split("\n")
      if res[0] == 'BADSESSION'
        # This indicates that the Session ID sent was somehow invalid, possibly
        # because another client has performed a handshake for this user. On
        # receiving this, the client should re-handshake with the server before
        # continuing. 
        raise BadSessionError
      end
    end #^ now_playing
    
    def submit(tracks={})
    end #^ submit
  end
end
