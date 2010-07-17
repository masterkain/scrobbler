module Scrobbler
  class Session < Base
    attr_reader :key, :name, :subscriber
    
    def initialize(data={})
      populate_data(data)
    end
  end
end
