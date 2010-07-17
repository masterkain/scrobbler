require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Scrobbler::Library do

  before(:all) do 
    @library = Scrobbler::Library.new('xhochy')
  end
  
  it 'should know its username' do
    @library.user.should be_kind_of(Scrobbler::User)
    @library.user.name.should eql('xhochy')
  end
  
  it 'should implement all methods from the Last.fm 2.0 API' do
    @library.should respond_to(:add_album)
    @library.should respond_to(:add_artist)
    @library.should respond_to(:add_track)
    @library.should respond_to(:albums)
    @library.should respond_to(:artists)
    @library.should respond_to(:tracks)
  end
  
  it 'should be able to add an album'
  
  it 'should be able to add an artist'
  
  it 'should be able to add a track'
  
  it 'should be able to get its albums' do
    @library.should have(396).albums
    first = @library.albums.first
    first.should be_kind_of Scrobbler::Album
    first.name.should eql 'Silent Alarm'
    first.playcount.should eql 1043
    first.tagcount.should eql 0
    first.mbid.should eql '7e18e965-cbc7-43d6-9042-daba4f984a34'
    first.url.should eql 'http://www.last.fm/music/Bloc+Party/Silent+Alarm'
    first.artist.should be_kind_of Scrobbler::Artist
    first.artist.name.should eql 'Bloc Party'
    first.artist.mbid.should eql '8c538f11-c141-4588-8ecb-931083524186'
    first.artist.url.should eql 'http://www.last.fm/music/Bloc+Party'
    first.image(:small).should eql 'http://userserve-ak.last.fm/serve/34s/9903887.jpg'
    first.image(:medium).should eql 'http://userserve-ak.last.fm/serve/64s/9903887.jpg'
    first.image(:large).should eql 'http://userserve-ak.last.fm/serve/126/9903887.jpg'
  end
  
  it 'should be able to get its 30 most heard albums' do
    @library.albums(:all => false, :limit => 30).should have(30).items
    first = @library.albums(:all => false, :limit => 30).first
    first.should be_kind_of Scrobbler::Album
    first.name.should eql 'Silent Alarm'
    first.playcount.should eql 1043
    first.tagcount.should eql 0
    first.mbid.should eql '7e18e965-cbc7-43d6-9042-daba4f984a34'
    first.url.should eql 'http://www.last.fm/music/Bloc+Party/Silent+Alarm'
    first.artist.should be_kind_of Scrobbler::Artist
    first.artist.name.should eql 'Bloc Party'
    first.artist.mbid.should eql '8c538f11-c141-4588-8ecb-931083524186'
    first.artist.url.should eql 'http://www.last.fm/music/Bloc+Party'
    first.image(:small).should eql 'http://userserve-ak.last.fm/serve/34s/9903887.jpg'
    first.image(:medium).should eql 'http://userserve-ak.last.fm/serve/64s/9903887.jpg'
    first.image(:large).should eql 'http://userserve-ak.last.fm/serve/126/9903887.jpg'
  end
  
  it 'should be able to get its artists' do
    @library.should have(340).artists
    first = @library.artists.first
    first.should be_kind_of Scrobbler::Artist
    first.name.should eql 'Bloc Party'
    first.playcount.should eql 2314
    first.tagcount.should eql 0
    first.mbid.should eql '8c538f11-c141-4588-8ecb-931083524186'
    first.url.should eql 'http://www.last.fm/music/Bloc+Party'
    first.streamable.should be_true
    first.image(:small).should eql 'http://userserve-ak.last.fm/serve/34/115908.jpg'
    first.image(:medium).should eql 'http://userserve-ak.last.fm/serve/64/115908.jpg'
    first.image(:large).should eql 'http://userserve-ak.last.fm/serve/126/115908.jpg'
  end

  it 'should be able to get its 30 most heard artists' do
    @library.artists(:all => false, :limit => 30).should have(30).items
    first = @library.artists(:all => false, :limit => 30).first
    first.should be_kind_of Scrobbler::Artist
    first.name.should eql 'Bloc Party'
    first.playcount.should eql 2314
    first.tagcount.should eql 0
    first.mbid.should eql '8c538f11-c141-4588-8ecb-931083524186'
    first.url.should eql 'http://www.last.fm/music/Bloc+Party'
    first.streamable.should be_true
    first.image(:small).should eql 'http://userserve-ak.last.fm/serve/34/115908.jpg'
    first.image(:medium).should eql 'http://userserve-ak.last.fm/serve/64/115908.jpg'
    first.image(:large).should eql 'http://userserve-ak.last.fm/serve/126/115908.jpg'
  end
  
  it 'should be able to get its tracks' do
    @library.should have(1686).tracks
    first = @library.tracks.first
    first.should be_kind_of Scrobbler::Track
    first.name.should eql 'A-Punk'
    first.playcount.should eql 185
    first.tagcount.should eql 0
    first.mbid.should eql ''
    first.url.should eql 'http://www.last.fm/music/Vampire+Weekend/_/A-Punk'
    first.streamable.should be_false
    first.artist.should be_kind_of Scrobbler::Artist
    first.artist.name.should eql 'Vampire Weekend'
    first.artist.mbid.should eql 'af37c51c-0790-4a29-b995-456f98a6b8c9'
    first.artist.url.should eql 'http://www.last.fm/music/Vampire+Weekend'
    first.image(:small).should eql 'http://userserve-ak.last.fm/serve/34s/10258165.jpg'
    first.image(:medium).should eql 'http://userserve-ak.last.fm/serve/64s/10258165.jpg'
    first.image(:large).should eql 'http://userserve-ak.last.fm/serve/126/10258165.jpg'
  end
  
  it 'should be able to get its 30 most heard tracks' do
    @library.tracks(:all => false, :limit => 30).should have(30).items
    first = @library.tracks(:all => false, :limit => 30).first
    first.should be_kind_of Scrobbler::Track
    first.name.should eql 'A-Punk'
    first.playcount.should eql 185
    first.tagcount.should eql 0
    first.mbid.should eql ''
    first.url.should eql 'http://www.last.fm/music/Vampire+Weekend/_/A-Punk'
    first.streamable.should be_false
    first.artist.should be_kind_of Scrobbler::Artist
    first.artist.name.should eql 'Vampire Weekend'
    first.artist.mbid.should eql 'af37c51c-0790-4a29-b995-456f98a6b8c9'
    first.artist.url.should eql 'http://www.last.fm/music/Vampire+Weekend'
    first.image(:small).should eql 'http://userserve-ak.last.fm/serve/34s/10258165.jpg'
    first.image(:medium).should eql 'http://userserve-ak.last.fm/serve/64s/10258165.jpg'
    first.image(:large).should eql 'http://userserve-ak.last.fm/serve/126/10258165.jpg'
  end
  
end
