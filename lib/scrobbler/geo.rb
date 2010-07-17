module Scrobbler
  class Geo < Base

    # Gets a list of events based on the location that
    # the Geo object is set to
    def events(options={})
      options = set_default_options(options)
      get_response('geo.getevents', :events, 'events', 'event', options, options[:force])
    end

    def top_artists(options={})
      options = set_default_options(options)
      get_response('geo.gettopartists', :artists, 'topartists', 'artist', options, options[:force])
    end

    def top_tracks(options={})
      options = set_default_options(options)
      get_response('geo.gettoptracks', :tracks, 'toptracks', 'track', options, options[:force])
    end

    private

    def set_default_options(options={})
      {:force => false, :page => 1}.merge options
    end
  end
end