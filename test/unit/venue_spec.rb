require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Scrobbler::Venue do
  before do
    xml =  LibXML::XML::Document.file(File.dirname(__FILE__) + '/../fixtures/xml/venue/venue.xml')
    @venue = Scrobbler::Venue.new_from_xml(xml.root)
    @event_ids = [875740, 950267, 1082373, 1059277]
    @event_titles =  ["Kilians", "Convention of the Universe - International Depeche Mode Fan Event", "The Get Up Kids", "Philipp Poisel"]
  end

  describe 'should implement the method' do
    [:events,:past_events].each do |method_name|
      it "'#{method_name}'" do
        @venue.should respond_to(method_name)
      end
    end

    it 'search' do
      Scrobbler::Venue.should respond_to(:search)
    end
  end

  describe 'a Venue built from XML should have' do
    it 'an ID' do
      @venue.id.should eql(9027137)
    end

    it 'a name' do
      @venue.name.should eql('Karrera Klub')
    end

    it 'a city' do
      @venue.city.should eql('Berlin')
    end

    it 'a country' do
      @venue.country.should eql('Germany')
    end
    
    it 'a street' do
      @venue.street.should eql('Neue Promenade 10')
    end

    it 'a postalcode' do
      @venue.postalcode.should eql('10178')
    end

    it 'a geo_lat' do
      @venue.geo_lat.should eql('52.532019')
    end
      
    it 'a geo_long' do
      @venue.geo_long.should eql('13.427965')
    end

    it 'a timezone' do
      @venue.timezone.should eql('CET')
    end

    it 'a URL' do
      @venue.url.should eql('http://www.last.fm/venue/9027137')
    end
  end

  describe 'finding events for Postbahnhof, Berlin' do
    before do
      @events = @venue.events
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

  describe 'finding past events for Postbahnhof, Berlin' do
    before do
      @events = @venue.past_events
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

  describe 'searching for venues' do
    #TODO
  end
end
