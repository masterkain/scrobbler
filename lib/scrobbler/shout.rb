module Scrobbler
  class Shout < Base
    attr_reader :author, :date, :body
    
    class << self
      def new_from_libxml(xml)
        data={}
        xml.children.each do |child|
          data[:body] = child.content if child.name == 'body'
          data[:author] = Scrobbler::User.new(child.content) if child.name == 'author'
          data[:date] = Time.parse(child.content) if child.name == 'date'
        end
        Shout.new(data)
      end
    end

    def initialize(input={})
      populate_data(input)
    end
  end
end
