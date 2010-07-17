require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Scrobbler::Artist do

  before(:each) do 
    @artist = Scrobbler::Artist.new('Metallica')
  end
  
  it 'should know its name' do
    @artist.name.should eql('Metallica')
  end

  it 'should implement all methods from the Last.fm 2.0 API' do
    @artist.should respond_to(:add_tags)
    @artist.should respond_to(:events)
    @artist.should respond_to(:images)
    @artist.should respond_to(:load_info)
    @artist.should respond_to(:shouts)
    @artist.should respond_to(:similar)
    @artist.should respond_to(:tags)
    @artist.should respond_to(:top_albums)
    @artist.should respond_to(:top_fans)
    @artist.should respond_to(:top_tags)
    @artist.should respond_to(:top_tracks)
    @artist.should respond_to(:remove_tag)
    @artist.should respond_to(:search)
    @artist.should respond_to(:share)
    @artist.should respond_to(:shout)
  end
  
  it 'should be able to add tags'
  
  it 'should be able to load a list of upcoming events'
  
  it 'should be able to get images for this artist in a variety of sizes'
  
  it 'should be able to load the artist info' do
    @artist.load_info
    @artist.mbid.should eql('bfcc6d75-a6a5-4bc6-8282-47aec8531818')
    @artist.url.should eql('http://www.last.fm/music/Cher')
    @artist.image(:small).should eql('http://userserve-ak.last.fm/serve/34/9137697.jpg')
    @artist.image(:medium).should eql('http://userserve-ak.last.fm/serve/64/9137697.jpg')
    @artist.image(:large).should eql('http://userserve-ak.last.fm/serve/126/9137697.jpg')
    @artist.streamable.should be_true
    @artist.listeners.should eql(383775)
    @artist.playcount.should eql(3141583)
  end
  
  it 'should be able to get shouts for this artist'
  
  it 'should be able to get all the artists similar to this artist' do
    @artist.similar.should be_kind_of(Array)
    @artist.similar.should have(100).items
    @artist.similar.first.should be_kind_of(Scrobbler::Artist)
    @artist.similar.first.name.should eql('Megadeth')
    @artist.similar.first.mbid.should eql('a9044915-8be3-4c7e-b11f-9e2d2ea0a91e')
    @artist.similar.first.match.should eql(100)
    @artist.similar.first.url.should eql('www.last.fm/music/Megadeth')
    @artist.similar.first.image(:small).should eql('http://userserve-ak.last.fm/serve/34/8422011.jpg')
    @artist.similar.first.image(:medium).should eql('http://userserve-ak.last.fm/serve/64/8422011.jpg')
    @artist.similar.first.image(:large).should eql('http://userserve-ak.last.fm/serve/126/8422011.jpg')
    @artist.similar.first.image(:small).should eql('http://userserve-ak.last.fm/serve/34/8422011.jpg')
    @artist.similar.first.streamable.should be_true
  end
  
  it 'should be able to get the tags applied by a user'
  
  it 'should be able to get the top albums' do
    @artist.top_albums.should be_kind_of(Array)
    @artist.top_albums.should have(4).items
    @artist.top_albums.first.should be_kind_of(Scrobbler::Album)
    @artist.top_albums.first.name.should eql('Master of Puppets')
    @artist.top_albums.first.playcount.should eql(1165854)
    @artist.top_albums.first.mbid.should eql('fed37cfc-2a6d-4569-9ac0-501a7c7598eb')
    @artist.top_albums.first.url.should eql('http://www.last.fm/music/Metallica/Master+of+Puppets')
    @artist.top_albums.first.artist.should be_kind_of(Scrobbler::Artist)
    @artist.top_albums.first.artist.name.should eql('Metallica')
    @artist.top_albums.first.artist.mbid.should eql('65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab')
    @artist.top_albums.first.artist.url.should eql('http://www.last.fm/music/Metallica')
    @artist.top_albums.first.image(:small).should eql('http://userserve-ak.last.fm/serve/34s/8622967.jpg')
    @artist.top_albums.first.image(:medium).should eql('http://userserve-ak.last.fm/serve/64s/8622967.jpg')
    @artist.top_albums.first.image(:large).should eql('http://userserve-ak.last.fm/serve/126/8622967.jpg')
  end
  
  it 'should be able to get the top fans' do
    @artist.top_fans.should be_kind_of(Array)
    @artist.top_fans.should have(6).items
    @artist.top_fans.first.should be_kind_of(Scrobbler::User)
    @artist.top_fans.first.username.should eql('Slide15')
    @artist.top_fans.first.url.should eql('http://www.last.fm/user/Slide15')
    @artist.top_fans.first.image(:small).should eql('http://userserve-ak.last.fm/serve/34/4477633.jpg')
    @artist.top_fans.first.image(:medium).should eql('http://userserve-ak.last.fm/serve/64/4477633.jpg')
    @artist.top_fans.first.image(:large).should eql('http://userserve-ak.last.fm/serve/126/4477633.jpg')
    @artist.top_fans.first.weight.should eql(265440672)
  end
  
  it 'should be able to get the top tags' do
    @artist.top_tags.should be_kind_of(Array)
    @artist.top_tags.should have(3).items
    @artist.top_tags.first.should be_kind_of(Scrobbler::Tag)
    @artist.top_tags.first.name.should eql('metal')
    @artist.top_tags.first.count.should eql(100)
    @artist.top_tags.first.url.should eql('http://www.last.fm/tag/metal')
  end
  
  it 'should be able to get the top tracks' do
    @artist.top_tracks.should be_kind_of(Array)
    @artist.top_tracks.should have(4).items
    @artist.top_tracks.first.should be_kind_of(Scrobbler::Track)
    @artist.top_tracks.first.rank.should eql(1)
    @artist.top_tracks.first.name.should eql('Nothing Else Matters')
    @artist.top_tracks.first.playcount.should eql(537704)
    @artist.top_tracks.first.mbid.should eql('')
    @artist.top_tracks.first.url.should eql('http://www.last.fm/music/Metallica/_/Nothing+Else+Matters')
    @artist.top_tracks.first.artist.should be_kind_of(Scrobbler::Artist)
    @artist.top_tracks.first.artist.name.should eql('Metallica')
    @artist.top_tracks.first.artist.url.should eql('http://www.last.fm/music/Metallica')
    @artist.top_tracks.first.artist.mbid.should eql('65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab')
    @artist.top_tracks.first.image(:small).should eql('http://userserve-ak.last.fm/serve/34s/8622943.jpg')
    @artist.top_tracks.first.image(:medium).should eql('http://userserve-ak.last.fm/serve/64s/8622943.jpg')
    @artist.top_tracks.first.image(:large).should eql('http://userserve-ak.last.fm/serve/126/8622943.jpg')
  end
  
  it 'should be able to remove tags'
  
  it 'should be able to search for an artist'
  
  it 'should be able to leave a shout'

end
