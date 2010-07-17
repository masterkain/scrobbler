require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Scrobbler::Playlist do

  before(:all) do 
    @playlist = Scrobbler::Playlist.new('lastfm://playlist/album/2026126')
  end
  
  it 'should know its url' do
    @playlist.url.should eql('lastfm://playlist/album/2026126')
  end
  
  it 'should implement all methods from the Last.fm 2.0 API' do
    @playlist.should respond_to(:fetch)
    @playlist.should respond_to(:add_track)
    Scrobbler::Playlist.should respond_to(:create)
  end
  
  it 'should be able to add a track'
  
  it 'should be able to create a new'
  
  it 'should be able to fetch more information'

end
