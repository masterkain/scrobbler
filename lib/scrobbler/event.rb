module Scrobbler
  class Event < Base
    # Load Helper modules
    include ImageObjectFuncs
    extend  ImageClassFuncs
    
    attr_accessor :id, :title, :start_date, :start_time, :description
    attr_accessor :reviews, :tag, :url, :artists, :headliner, :image_small
    attr_accessor :image_medium, :image_large, :attendance, :venue
    
    class << self

      def update_or_create_from_xml(xml, event=nil)
        data = {}
        artists = []
        headliner = nil
        venue = nil

        xml.children.each do |child|
          data[:id] = child.content.to_i if child.name == 'id'
          data[:title] = child.content if child.name == 'title'

          if child.name == 'artists'
            child.children.each do |artist_element|
              artists << Artist.new(artist_element.content) if artist_element.name == 'artist'
              headliner = Artist.new(artist_element.content) if artist_element.name == 'headliner'
            end
            artists << headliner unless headliner.nil? || headliner_alrady_listed_in_artist_list?(artists,headliner)
          end

          maybe_image_node(data, child)
          data[:url] = child.content if child.name == 'url'
          data[:description] = child.content if child.name == 'description'
          data[:attendance] = child.content.to_i if child.name == 'attendance'
          data[:reviews]    = child.content.to_i if child.name == 'reviews'
          data[:tag]        = child.content if child.name == 'tag'
          data[:start_date] = Time.parse(child.content) if child.name == 'startDate'
          data[:start_time] = child.content if child.name == 'startTime'
          venue = Venue.new_from_xml(child) if child.name == 'venue'
        end

        if event.nil?
          event = Event.new(data[:id],data)
        else
          event.send :populate_data, data
        end

        event.artists = artists.uniq
        event.headliner = headliner
        event.venue = venue
        event
      end

      def headliner_alrady_listed_in_artist_list?(artists,headliner)
        artists.each do |artist|
          return true if artist.name == headliner.name
        end
        false
      end

      def new_from_libxml(xml)
        update_or_create_from_xml(xml)
      end
    end

    def initialize(id,input={})
      raise ArgumentError if id.blank?
      @id = id
      populate_data(input)
      load_info() if input[:include_info]
    end

    def shouts(force = false)
      get_response('event.getshouts', :shouts, 'shouts', 'shout', {'event'=>@id}, force)
    end

    def attendees(force = false)
      get_response('event.getattendees', :attendees, 'attendees', 'user', {'event'=>@id}, force)
    end

    def shout
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

    def attend(session, attendance_status)
      doc = Base.post_request('event.attend',{:event => @id, :signed => true, :status => attendance_status, :sk => session.key})
    end

    def share
      # This function require authentication, but SimpleAuth is not yet 2.0
      raise NotImplementedError
    end

    # Load additional informatalbumion about this event
    #
    # Calls "event.getinfo" REST method
    def load_info
      doc = Base.request('event.getinfo', {'event' => @id})
      doc.root.children.each do |child|        
        Event.update_or_create_from_xml(child, self) if child.name == 'event'
      end      
    end
  end
end
