require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Scrobbler::Tag do

  before(:all) do 
    @tag = Scrobbler::Tag.new('rock')
  end
  
  it 'should know its name' do
    @tag.name.should eql('rock')
  end
  
  it 'should implement all methods from the Last.fm 2.0 API' do
    @tag.should respond_to(:similar)
    @tag.should respond_to(:top_albums)
    @tag.should respond_to(:top_artists)
    Scrobbler::Tag.should respond_to(:top_tags)
    @tag.should respond_to(:top_tracks)
    @tag.should respond_to(:weekly_artist_chart)
    @tag.should respond_to(:weekly_chart_list)
    Scrobbler::Tag.should respond_to(:search)
  end
  
  it 'should be able to get similar tags' do
    @tag.should have(50).similar
    first = @tag.similar.first
    first.should be_kind_of(Scrobbler::Tag)
    first.name.should eql('classic rock')
    first.url.should eql('http://www.last.fm/tag/classic%20rock')
    first.streamable.should be_true
  end
  
  it 'should be able to find its top albums' do
    @tag.top_albums.should be_kind_of(Array)
    @tag.top_albums.should have(50).items
    @tag.top_albums.first.should be_kind_of(Scrobbler::Album)
    @tag.top_albums.first.rank.should eql(1)
    @tag.top_albums.first.name.should eql('Overpowered')
    @tag.top_albums.first.tagcount.should eql(105)
    @tag.top_albums.first.mbid.should eql('')
    @tag.top_albums.first.url.should eql('http://www.last.fm/music/R%C3%B3is%C3%ADn+Murphy/Overpowered')
    @tag.top_albums.first.artist.should be_kind_of(Scrobbler::Artist)
    @tag.top_albums.first.artist.name.should eql('Róisín Murphy')
    @tag.top_albums.first.artist.mbid.should eql('4c56405d-ba8e-4283-99c3-1dc95bdd50e7')
    @tag.top_albums.first.artist.url.should eql('http://www.last.fm/music/R%C3%B3is%C3%ADn+Murphy')
    @tag.top_albums.first.image(:small).should eql('http://userserve-ak.last.fm/serve/34s/26856969.png')
    @tag.top_albums.first.image(:medium).should eql('http://userserve-ak.last.fm/serve/64s/26856969.png')
    @tag.top_albums.first.image(:large).should eql('http://userserve-ak.last.fm/serve/126/26856969.png')
  end
  
  it 'should be able to find its top artists' do
    @tag.top_artists.should be_kind_of(Array)
    @tag.top_artists.should have(50).items
    @tag.top_artists.first.should be_kind_of(Scrobbler::Artist)
    @tag.top_artists.first.rank.should eql(1)
    @tag.top_artists.first.name.should eql('ABBA')
    @tag.top_artists.first.tagcount.should eql(1229)
    @tag.top_artists.first.mbid.should eql('d87e52c5-bb8d-4da8-b941-9f4928627dc8')
    @tag.top_artists.first.url.should eql('http://www.last.fm/music/ABBA')
    @tag.top_artists.first.streamable.should be_true
    @tag.top_artists.first.image(:small).should eql('http://userserve-ak.last.fm/serve/34/135930.jpg')
    @tag.top_artists.first.image(:medium).should eql('http://userserve-ak.last.fm/serve/64/135930.jpg')
    @tag.top_artists.first.image(:large).should eql('http://userserve-ak.last.fm/serve/126/135930.jpg')
  end
  
  it 'should be able to find global top tags' do
    Scrobbler::Tag.should have(250).top_tags
    first = Scrobbler::Tag.top_tags.first
    first.should be_kind_of(Scrobbler::Tag)
    first.name.should eql('rock')
    first.count.should eql(2267576)
    first.url.should eql('www.last.fm/tag/rock')
  end
  
  it 'should be able to find its top tracks' do
    @tag.top_tracks.should be_kind_of(Array)
    @tag.top_tracks.should have(50).items
    @tag.top_tracks.first.should be_kind_of(Scrobbler::Track)
    @tag.top_tracks.first.rank.should eql(1)
    @tag.top_tracks.first.name.should eql('Stayin\' Alive')
    @tag.top_tracks.first.tagcount.should eql(422)
    @tag.top_tracks.first.mbid.should eql('')
    @tag.top_tracks.first.streamable.should be_true
    @tag.top_tracks.first.url.should eql('http://www.last.fm/music/Bee+Gees/_/Stayin%27+Alive')
    @tag.top_tracks.first.artist.should be_kind_of(Scrobbler::Artist)
    @tag.top_tracks.first.artist.name.should eql('Bee Gees')
    @tag.top_tracks.first.artist.mbid.should eql('bf0f7e29-dfe1-416c-b5c6-f9ebc19ea810')
    @tag.top_tracks.first.artist.url.should eql('http://www.last.fm/music/Bee+Gees')
    @tag.top_tracks.first.image(:small).should eql('http://images.amazon.com/images/P/B00069590Q.01._SCMZZZZZZZ_.jpg')
    @tag.top_tracks.first.image(:medium).should eql('http://images.amazon.com/images/P/B00069590Q.01._SCMZZZZZZZ_.jpg')
    @tag.top_tracks.first.image(:large).should eql('http://images.amazon.com/images/P/B00069590Q.01._SCMZZZZZZZ_.jpg')
  end
  
  it 'should be able to get the weekly artist chart'
  
  it 'should be able to get the weekly chart list'
  
  it 'should be able to search for a tag'
  
end

