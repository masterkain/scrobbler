require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Scrobbler::Geo do
  
  before do
    @geo = Scrobbler::Geo.new
  end

  describe 'should implement the method' do
    [:events,:top_tracks,:top_artists].each do |method_name|
      it "'#{method_name}'" do
        @geo.should respond_to(method_name)
      end
    end
  end

  describe 'finding by location' do
    before do
      @event_titles = ['Will and The People','Son Of Dave','Surface Unsigned','Experimental Dental School']
      @event_ids = [1025661,954053,1005964,909456]
      @first_atrists_names = ['Will And The People','Carnations','Midwich Cuckoos','NO FLASH']
      @first_headliner = 'Will And The People'
      @top_artist_names = ['The Killers','Coldplay','Radiohead','Muse','Franz Ferdinand','U2']
      @top_track_names = ['Use Somebody','Schwarz zu Blau','Sex on Fire','Alles Neu','Poker Face','Ayo Technology']
    end
    
    describe 'events in manchester' do
      before do
        @events =  @geo.events(:location => 'Manchester')
      end

      it 'should find 4 events' do
        @events.size.should eql 4
      end
   
      it "should have the correct event id's" do
        @events.collect(&:id).should eql @event_ids
      end

      it 'should have the correct event titles' do
        @events.collect(&:title).should eql @event_titles
      end
    end

    describe 'finding top artists in spain' do
      before do
        @top_artists = @geo.top_artists(:location => 'Spain')
      end

      it 'should find 6 artists' do
        @top_artists.size.should eql 6
      end

      it 'should have the correct artist names' do
        @top_artists.collect(&:name).should eql @top_artist_names
      end
    end

    describe 'finding top tracks in germany' do
      before do
        @top_tracks = @geo.top_tracks(:location => 'Germany')
      end

      it 'should find 6 top tracks' do
        @top_tracks.size.should eql 6
      end

      it 'should have the correct top track names' do
        @top_track_names.should eql @top_tracks.collect(&:name)
      end
    end
  end


  describe 'finding by latitude and longitude' do
    describe 'events in 40.71417 -74.00639' do
      before do
        @events =  @geo.events(:lat => 40.71417, :long => -74.00639)
        @event_ids = [1066470, 990602, 1062713, 1088394]
        @event_titles = ["We Love Brasil", "Red Bank Jazz and Blues Festival", "Jazz For Young People", "The Paul Green School Of Rock"]
      end

      it 'should find 4 events' do
        @events.size.should eql 4
      end

      it "should have the correct event id's" do
        @events.collect(&:id).should eql @event_ids
      end

      it 'should have the correct event titles' do
        @events.collect(&:title).should eql @event_titles
      end
    end   
  end

  describe 'finding  by distance' do
    describe 'events within 15km' do
      before do
        @events =  @geo.events(:distance => 15)
        @event_ids = [926134, 1046018, 1070375, 805363]
        @event_titles = ["Feast - Picnic by the Lake", "Bootleg Beatles", "The Lucid Dream", "Oasis"]
      end

      it 'should find 4 events' do
        @events.size.should eql 4
      end

      it "should have the correct event id's" do
        @events.collect(&:id).should eql @event_ids
      end

      it 'should have the correct event titles' do
        @events.collect(&:title).should eql @event_titles
      end
    end
  end

  describe 'pagination' do
    describe 'page two of events in manchester' do
      before do
        @page = @geo.events(:location => 'Manchester', :page => 2)
      end

      it 'should have 10 events' do
        @page.size.should eql(10)
      end
      
      it 'should have the correct title for the first event' do
        @page.first.title.should eql('New Bruises')
      end
    end

    describe 'page three of events in manchester' do
      before do         
        @page = @geo.events(:location => 'Manchester', :page => 3)
      end
      
      it 'should have 10 events' do
        @page.size.should eql(10)
      end

      it 'should have the correct title for the first event' do
        @page.first.title.should eql('Saving Aimee')
      end
    end
  end
end