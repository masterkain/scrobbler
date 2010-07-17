require File.dirname(__FILE__) + '/../../lib/scrobbler/rest'
require 'rubygems'
require 'fakeweb'
require 'digest/md5'

FIXTURES_BASE = File.join([File.dirname(__FILE__), '..', 'fixtures', 'xml'])
FakeWeb.allow_net_connect = false

## Library
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.getalbums&force=false&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'albums-p1.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.getalbums&force=false&page=2&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'albums-p2.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.getalbums&force=false&page=3&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'albums-p3.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.getalbums&force=false&page=4&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'albums-p4.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.getalbums&force=false&page=5&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'albums-p5.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.getalbums&force=false&page=6&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'albums-p6.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.getalbums&force=false&page=7&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'albums-p7.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.getalbums&force=false&page=8&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'albums-p8.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.getalbums&limit=30&force=false&api_key=foo123&user=xhochy&all=false', :body => File.join([FIXTURES_BASE, 'library', 'albums-f30.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.getartists&force=false&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'artists-p1.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.getartists&force=false&page=2&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'artists-p2.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.getartists&force=false&page=3&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'artists-p3.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.getartists&force=false&page=4&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'artists-p4.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.getartists&force=false&page=5&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'artists-p5.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.getartists&force=false&page=6&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'artists-p6.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.getartists&force=false&page=7&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'artists-p7.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.getartists&limit=30&force=false&api_key=foo123&user=xhochy&all=false', :body => File.join([FIXTURES_BASE, 'library', 'artists-f30.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p1.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=2&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p2.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=3&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p3.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=4&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p4.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=5&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p5.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=6&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p6.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=7&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p7.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=8&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p8.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=9&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p9.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=10&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p10.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=11&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p11.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=12&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p12.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=13&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p13.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=14&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p14.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=15&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p15.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=16&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p16.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=17&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p17.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=18&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p18.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=19&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p19.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=20&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p20.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=21&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p21.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=22&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p22.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=23&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p23.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=24&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p24.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=25&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p25.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=26&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p26.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=27&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p27.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=28&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p28.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=29&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p29.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=30&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p30.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=31&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p31.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=32&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p32.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=33&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p33.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&force=false&page=34&api_key=foo123&user=xhochy&all=true', :body => File.join([FIXTURES_BASE, 'library', 'tracks-p34.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=library.gettracks&limit=30&force=false&api_key=foo123&user=xhochy&all=false', :body => File.join([FIXTURES_BASE, 'library', 'tracks-f30.xml']))

## Event
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=event.getattendees&event=328799&api_key=foo123', :body => File.join([FIXTURES_BASE, 'event', 'attendees.xml']))
FakeWeb.register_uri(:post, 'http://ws.audioscrobbler.com:80/2.0/?api_key=foo123&event=328799&method=event.attend&sk=d580d57f32848f5dcf574d1ce18d78b2&status=1&api_sig=c476ec753082205327b0f6ef922d82c8', :body => File.join([FIXTURES_BASE, 'event', 'attend.xml']))


## Tag
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=tag.gettoptags&api_key=foo123', :body => File.join([FIXTURES_BASE, 'tag', 'toptags.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=tag.getsimilar&tag=rock&api_key=foo123', :body => File.join([FIXTURES_BASE, 'tag', 'similar.xml']))

## Venue
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=venue.getevents&api_key=foo123&venue=9027137', :body => File.join([FIXTURES_BASE, 'venue', 'events.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=venue.getpastevents&api_key=foo123&venue=9027137', :body => File.join([FIXTURES_BASE, 'venue', 'events.xml']))

## Auth
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?api_key=foo123&method=auth.gettoken&api_sig=d062b3b3fa109d048732819d27d04689', :body => File.join([FIXTURES_BASE, 'auth', 'token.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?api_key=foo123&method=auth.getsession&token=test123token&api_sig=f4a839c10a010368bd1058725c253dfb', :body => File.join([FIXTURES_BASE, 'auth', 'session.xml']))

## Artist
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?artist=Metallica&method=artist.getinfo&api_key=foo123', :body => File.join([FIXTURES_BASE, 'artist', 'info.xml']))

## Track
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?api_key=foo123&method=track.getinfo&artist=Carrie%20Underwood&track=Before%20He%20Cheats', :body => File.join([FIXTURES_BASE, 'track', 'info.xml']))


## Geo
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=geo.getevents&api_key=foo123&page=1&force=false&location=Manchester', :body => File.join([FIXTURES_BASE, 'geo', 'events-p1.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=geo.getevents&api_key=foo123&page=2&force=false&location=Manchester', :body => File.join([FIXTURES_BASE, 'geo', 'events-p2.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=geo.getevents&api_key=foo123&page=3&force=false&location=Manchester', :body => File.join([FIXTURES_BASE, 'geo', 'events-p3.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?distance=15&method=geo.getevents&api_key=foo123&page=1&force=false', :body => File.join([FIXTURES_BASE, 'geo', 'events-distance-p1.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?long=-74.00639&method=geo.getevents&api_key=foo123&page=1&lat=40.71417&force=false', :body => File.join([FIXTURES_BASE, 'geo', 'events-lat-long.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=geo.gettopartists&api_key=foo123&page=1&force=false&location=Spain', :body => File.join([FIXTURES_BASE, 'geo', 'top_artists-p1.xml']))
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=geo.gettoptracks&api_key=foo123&page=1&force=false&location=Germany', :body => File.join([FIXTURES_BASE, 'geo', 'top_tracks-p1.xml']))

# User
FakeWeb.register_uri(:get, 'http://ws.audioscrobbler.com:80/2.0/?method=user.getplaylists&api_key=foo123&user=jnunemaker', :body => File.join([FIXTURES_BASE, 'user', 'playlists.xml']))



module Scrobbler
  module REST
  	class Connection
      alias :old_request :request
  	  # reads xml fixture file instead of hitting up the internets
  	  def request(resource, method = "get", args = nil)
  	    
  	    @now_playing_url = 'http://62.216.251.203:80/nowplaying'
  	    @submission_url = 'http://62.216.251.205:80/protocol_1.2'
  	    @session_id = '17E61E13454CDD8B68E8D7DEEEDF6170'
  	    
  	    if @base_url == Scrobbler::API_URL
    	    pieces = resource.split('/')
          pieces.shift
    	    api_version = pieces.shift
          if api_version == "1.0"
            folder = pieces.shift
            file   = pieces.last[0, pieces.last.index('.xml')]
            base_pieces = pieces.last.split('?')

            file = if base_pieces.size > 1
              # if query string params are in resource they are underscore separated for filenames
              base_pieces.last.split('&').inject("#{file}_") { |str, pair| str << pair.split('=').join('_') + '_'; str }.chop!
            else
              file
            end

            File.read(File.dirname(__FILE__) + "/../fixtures/xml/#{folder}/#{file}.xml")
          elsif api_version == "2.0"
            method_pieces = pieces.last.split('&')
            api_method = method_pieces.shift
            if api_method == '?method=artist.search'
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/search/artist.xml")
            elsif api_method == '?method=album.search'
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/search/album.xml")
            elsif api_method == '?method=track.search'
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/search/track.xml")
            elsif pieces.last =~ /[?&]method=album\.getinfo/
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/album/info.xml")
            elsif pieces.last =~ /[?&]method=artist\.gettoptags/
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/artist/toptags.xml")
            elsif pieces.last =~ /[?&]method=artist\.gettopfans/
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/artist/fans.xml")
            elsif pieces.last =~ /[?&]method=artist\.gettoptracks/
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/artist/toptracks.xml")
            elsif pieces.last =~ /[?&]method=artist\.gettopalbums/
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/artist/topalbums.xml")
            elsif pieces.last =~ /[?&]method=artist\.getsimilar/
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/artist/similar.xml")
            elsif pieces.last =~ /[?&]method=tag\.gettoptracks/
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/tag/toptracks.xml")
            elsif pieces.last =~ /[?&]method=tag\.gettopartists/
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/tag/topartists.xml")
            elsif pieces.last =~ /[?&]method=tag\.gettopalbums/
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/tag/topalbums.xml")
            elsif pieces.last =~ /[?&]method=track\.gettoptags/
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/track/toptags.xml")
            elsif pieces.last =~ /[?&]method=track\.gettopfans/
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/track/fans.xml")
            elsif pieces.last =~ /[?&]method=user\.getlovedtracks/
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/user/lovedtracks.xml")
            elsif pieces.last =~ /[?&]method=user\.gettopartists/
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/user/topartists.xml")
            elsif pieces.last =~ /[?&]method=user\.gettopalbums/
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/user/topalbums.xml")
            elsif pieces.last =~ /[?&]method=user\.gettoptracks/
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/user/toptracks.xml")
            elsif pieces.last =~ /[?&]method=user\.getfriends/
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/user/friends.xml")
            elsif pieces.last =~ /[?&]method=user\.gettoptags/
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/user/toptags.xml")
            elsif pieces.last =~ /[?&]method=user\.getneighbours/
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/user/neighbours.xml")
            elsif pieces.last =~ /[?&]method=user\.getrecenttracks/
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/user/recenttracks.xml")
            elsif pieces.last =~ /[?&]method=event\.getinfo/
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/event/event.xml")
            elsif pieces.last =~ /[?&]method=event\.getshouts/
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/event/shouts.xml")
            elsif pieces.last =~ /[?&]method=user\.getweeklyalbumchart/
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/user/weeklyalbumchart.xml")
            elsif pieces.last =~ /[?&]method=user\.getweeklyartistchart/
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/user/weeklyartistchart.xml")
            elsif pieces.last =~ /[?&]method=user\.getweeklytrackchart/
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/user/weeklytrackchart.xml")
            elsif pieces.last =~ /[?&]method=user\.getevents/
              return File.read(File.dirname(__FILE__) + "/../fixtures/xml/user/events.xml")
            else
              old_request(resource, method, args)
            end
          end
  	    elsif @base_url == Scrobbler::AUTH_URL
          if args[:hs] == "true" && args[:p] == Scrobbler::AUTH_VER.to_s && args[:c] == 'rbs' &&
              args[:v] == '0.2.13' && args[:u] == 'chunky' && !args[:t].blank? &&
              args[:a] == Digest::MD5.hexdigest('7813258ef8c6b632dde8cc80f6bda62f' + args[:t])
            
            "OK\n#{@session_id}\n#{@now_playing_url}\n#{@submission_url}"
          end
        elsif @base_url == @now_playing_url
          if args[:s] == @session_id && ![args[:a], args[:t], args[:b], args[:n]].any?(&:blank?)
            'OK'
          end           
        elsif @base_url == @submission_url
          if args[:s] == @session_id && 
              ![args['a[0]'], args['t[0]'], args['i[0]'], args['o[0]'], args['l[0]'], args['b[0]']].any?(&:blank?)
            'OK'
          end
	    end
	  end
	end
  end
end
