require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Scrobbler::Track do

  before(:all) do 
    @track = Scrobbler::Track.new(Scrobbler::Artist.new('Carrie Underwood'), 'Before He Cheats')
  end
  
  it 'should know the artist' do
    @track.artist.should be_kind_of(Scrobbler::Artist)
    @track.artist.name.should eql('Carrie Underwood')
  end
  
  it 'should know the name' do
    @track.name.should eql('Before He Cheats')
  end
  
  it 'should implement all methods from the Last.fm 2.0 API' do
    @track.should respond_to(:add_tags)
    @track.should respond_to(:ban)
    @track.should respond_to(:load_info)
    @track.should respond_to(:similar)
    @track.should respond_to(:tags)
    @track.should respond_to(:top_tags)
    @track.should respond_to(:top_fans)
    @track.should respond_to(:love)
    @track.should respond_to(:remove_tag)
    @track.should respond_to(:search)
    @track.should respond_to(:share)
  end
  
  it 'should be able to add tags'
  
  it 'should be able to be banned'
  
  it 'should be able to load more information' do
    @track.load_info
    @track.id.should eql(1019817)
    @track.mbid.should eql('')
    @track.url.should eql('http://www.last.fm/music/Cher/_/Believe')
    @track.duration.should eql(222000)
    @track.streamable.should be_true
    @track.listeners.should eql(114831)
    @track.playcount.should eql(435094)
    @track.artist.should be_kind_of(Scrobbler::Artist)
    @track.artist.name.should eql('Cher')
    @track.artist.mbid.should eql('bfcc6d75-a6a5-4bc6-8282-47aec8531818')
    @track.artist.url.should eql('http://www.last.fm/music/Cher')
    @track.album.should be_kind_of(Scrobbler::Album)
    @track.album.position.should eql(1)
    @track.album.artist.should be_kind_of(Scrobbler::Artist)
    @track.album.artist.name.should eql('Cher')
    @track.album.name.should eql('Believe')
    @track.album.mbid.should eql('61bf0388-b8a9-48f4-81d1-7eb02706dfb0')
    @track.album.url.should eql('http://www.last.fm/music/Cher/Believe')
    @track.album.image(:small).should eql('http://userserve-ak.last.fm/serve/64s/8674593.jpg')
    @track.album.image(:medium).should eql('http://userserve-ak.last.fm/serve/126/8674593.jpg')
    @track.album.image(:large).should eql('http://userserve-ak.last.fm/serve/174s/8674593.jpg')
  end
  
  it 'should be able to get similar tracks'
  
  it 'should be able to get the user\'s tags'
  
  it 'should be able to get its top tags' do
    @track.top_tags.should be_kind_of(Array)
    @track.top_tags.should have(100).items
    @track.top_tags.first.should be_kind_of(Scrobbler::Tag)
    @track.top_tags.first.name.should eql('pop')
    @track.top_tags.first.count.should eql(924808)
    @track.top_tags.first.url.should eql('www.last.fm/tag/pop')
  end
  
  it 'should be able to get its top fans' do
    @track.top_fans.should be_kind_of(Array)
    @track.top_fans.should have(3).items
    @track.top_fans.first.should be_kind_of(Scrobbler::User)
    @track.top_fans.first.name.should eql('ccaron0')
    @track.top_fans.first.url.should eql('http://www.last.fm/user/ccaron0')
    @track.top_fans.first.image(:small).should eql('')
    @track.top_fans.first.image(:medium).should eql('')
    @track.top_fans.first.image(:large).should eql('')
    @track.top_fans.first.weight.should eql(335873)
  end
  
  it 'should be able to love this track'
  
  it 'should be able to remove a tag'
  
  it 'should be able to search for a track'
  
  it 'should be able to share a track'
  
end

