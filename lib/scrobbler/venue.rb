module Scrobbler
  class Venue < Base
    attr_accessor :name, :city, :country, :street, :postalcode
    attr_accessor :geo_lat, :geo_long, :timezone, :url, :id

    class << self
      def new_from_xml(xml)
        data = {}
        xml.children.each do |child|
          data[:name] = child.content if child.name == 'name'
          data[:id] = child.content.to_i if child.name == 'id'
          data[:url] = child.content if child.name == 'url'          

          if child.name == 'location'
            child.children.each do |location_element|
              data[:city] = location_element.content if location_element.name == 'city'
              data[:country] = location_element.content if location_element.name == 'country'
              data[:street] = location_element.content if location_element.name == 'street'
              data[:postalcode] = location_element.content if location_element.name == 'postalcode'
              data[:timezone] = location_element.content if location_element.name == 'timezone'

              if location_element.name == 'point' || location_element.name == 'geo:point'
                location_element.children.each do |geo_element|
                  data[:geo_lat] = geo_element.content if ['lat', 'geo:lat'].include?(geo_element.name)
                  data[:geo_long] = geo_element.content if ['long', 'geo:long'].include?(geo_element.name)
                end
              end
            end
          end
        end

        if data.has_key?(:url) && !data.has_key?(:id)
          data[:id] = id_from_url(data[:url])
        end

        Venue.new(data[:name], data)
      end

      # this retrives the venue ID from 
      # the venue because the venue
      # ID is not supplied
      # in the XML apart from
      # in the venue URL
      def id_from_url(url)
        url[url.rindex('/')+1,url.length].to_i
      end

      def search(venue, force=false)
        get_response('venue.search', :venuematches, 'venuematches', 'venue', {'venue'=>venue}, force)
      end
    end

    def initialize(name,data = {})
      raise ArgumentError if name.blank?
      @name = name
      populate_data(data)
    end

    def events(force=false)
      get_response('venue.getevents', :events, 'events', 'event', {'venue'=>@id}, force)
    end

    def past_events(force=false)
      get_response('venue.getpastevents', :events, 'events', 'event', {'venue'=>@id}, force)
    end
  end
end
