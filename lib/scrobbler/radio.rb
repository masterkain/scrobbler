module Scrobbler
  # @todo everything
  class Radio < Base
    attr_reader :station
  
    def initialize(station)
      @station = station
    end
    
  end
end

