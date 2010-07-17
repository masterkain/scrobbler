require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Scrobbler::Event do

  before(:all) do
    @auth = Scrobbler::Auth.new('user')
    @session = @auth.session('test123token')
    @event = Scrobbler::Event.new(328799)
  end
  
  it 'should know its id' do
    @event.id.should eql(328799)
  end

  describe 'should implement the Last.fm 2.0 API method' do
    [:attend, :attendees, :load_info, :shouts, :share, :shout].each do |method_name|
      it "'#{method_name}'" do
        @event.should respond_to(method_name)
      end
    end
  end
  
  it 'should set user\'s status for attendace' do
    @event.attend(@session,1)
  end

  describe 'events attendees' do
    before do
      @attendees = ["ikea", "Schrollum", "Alpha1", "japps", "Gomhen", "NTG"]
    end

    it 'should have 6 attendees' do
      @event.attendees.size.should eql 6
    end

    it "should know it's attendees names" do
      @event.attendees.collect(&:name).should eql @attendees
    end

    describe 'first attendee' do
      before do
        @attendee = @event.attendees.first
      end

      it "should know it's realname" do
        @attendee.realname.should eql 'Jane'
      end
      
      it "should know it's small image" do
        @attendee.image(:small).should eql 'http://userserve-ak.last.fm/serve/34/17805805.jpg'
      end
      
      it "should know it's medium image" do
        @attendee.image(:medium).should eql 'http://userserve-ak.last.fm/serve/64/17805805.jpg'
      end
      
      it "should know it's large image" do
        @attendee.image(:large).should eql 'http://userserve-ak.last.fm/serve/126/17805805.jpg'
      end

      it "should know it's large url" do
        @attendee.url.should eql 'http://www.last.fm/user/ikea'
      end
    end
  end
  
  it 'should be able to load its info' do
    @event.load_info
    @event.title.should eql('Philip Glass')
    @event.artists.should be_kind_of(Array)
    @event.artists.first.should be_kind_of(Scrobbler::Artist)
    @event.artists.first.name.should eql('Philip Glass')
    @event.headliner.should be_kind_of(Scrobbler::Artist)
    @event.headliner.name.should eql('Philip Glass')
    @event.venue.should be_kind_of(Scrobbler::Venue)
    @event.venue.name.should eql('Barbican Centre')
    @event.venue.city.should eql('London')
    @event.venue.country.should eql('United Kingdom')
    @event.venue.street.should eql('Silk Street')
    @event.venue.postalcode.should eql('EC2Y 8DS')
    @event.venue.geo_lat.should eql('51.519972')
    @event.venue.geo_long.should eql('-0.09334')
    @event.venue.url.should eql('http://www.last.fm/venue/8777860')
    @event.start_date.should eql(Time.mktime(2008, 6, 12, 19, 30, 00))
    @event.description.should eql('Nunc vulputate, ante vitae sollicitudin ullamcorper, velit eros ultricies libero.')
    @event.image(:small).should eql('http://userserve-ak.last.fm/serve/34/320636.jpg')
    @event.image(:medium).should eql('http://userserve-ak.last.fm/serve/64/320636.jpg')
    @event.image(:large).should eql('http://userserve-ak.last.fm/serve/126/320636.jpg')
    @event.url.should eql('http://www.last.fm/event/328799')
    @event.attendance.should eql(46)
    @event.reviews.should eql(0)
    @event.tag.should eql('lastfm:event=328799')
  end
  
  it 'should be able to get its shouts' do 
    @event.shouts.should be_kind_of(Array)
    @event.shouts.should have(6).items
    @event.shouts.first.should be_kind_of(Scrobbler::Shout)
    @event.shouts.first.body.should eql('test')
    @event.shouts.first.author.should be_kind_of(Scrobbler::User)
    @event.shouts.first.author.username.should eql('kaypey')
    @event.shouts.first.date.should eql(Time.mktime(2009, 4, 28, 5, 35, 11))
  end
  
  it 'should be able to be shared'
  
  it 'should be able to leave a shout'
  
end
