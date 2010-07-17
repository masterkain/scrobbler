require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Scrobbler::User do

  before(:all) do 
    @user = Scrobbler::User.new('jnunemaker')
  end
  
  it 'should know its name' do
    @user.name.should eql('jnunemaker')
  end
  
  it 'should implement all methods from the Last.fm 2.0 API' do
    @user.should respond_to(:events)
    @user.should respond_to(:friends)
    @user.should respond_to(:load_info)
    @user.should respond_to(:loved_tracks)
    @user.should respond_to(:neighbours)
    @user.should respond_to(:past_events)
    @user.should respond_to(:playlists)
    @user.should respond_to(:recent_tracks)
    @user.should respond_to(:recommended_artists)
    @user.should respond_to(:recommended_events)
    @user.should respond_to(:shouts)
    @user.should respond_to(:top_albums)
    @user.should respond_to(:top_artists)
    @user.should respond_to(:top_tags)
    @user.should respond_to(:top_tracks)
    @user.should respond_to(:weekly_album_chart)
    @user.should respond_to(:weekly_artist_chart)
    @user.should respond_to(:weekly_chart_list)
    @user.should respond_to(:weekly_track_chart)
    @user.should respond_to(:shout)
  end
  
  it 'should be able to get a list of upcoming events this user is attending' do
    @user.events.should be_kind_of(Array)
    @user.events.should have(7).items
    @user.events.first.should be_kind_of(Scrobbler::Event)
    @user.events.first.id.should eql(1030003)
    @user.events.first.title.should eql('The Mars Volta')
    @user.events.first.headliner.should be_kind_of(Scrobbler::Artist)
    @user.events.first.headliner.name.should eql('The Mars Volta')
    @user.events.first.artists.should be_kind_of(Array)
    @user.events.first.artists.should have(1).items
    @user.events.first.artists.first.should be_kind_of(Scrobbler::Artist)
    @user.events.first.artists.first.name.should eql('The Mars Volta')
    @user.events.first.venue.should be_kind_of(Scrobbler::Venue)
    @user.events.first.venue.name.should eql('Somerset House')
    @user.events.first.venue.id.should eql(8796717)
    @user.events.first.venue.city.should eql('London')
    @user.events.first.venue.country.should eql('United Kingdom')
    @user.events.first.venue.street.should eql('Strand')
    @user.events.first.venue.postalcode.should eql('WC2R 1LA')
    @user.events.first.venue.geo_lat.should eql('51.510732')
    @user.events.first.venue.geo_long.should eql('-0.116937')
    @user.events.first.venue.url.should eql('http://www.last.fm/venue/8796717')
    @user.events.first.start_date.should eql(Time.mktime(2009, 07, 13, 19, 30, 00))
    @user.events.first.description.should eql('<div class="bbcode"><a href="http://www.nme.com/news/nme/44079" rel="nofollow">http://www.nme.com/news/nme/44079</a></div>')
  end
  
  it 'should be able to get a list of its friends' do
    @user.friends.should be_kind_of(Array)
    @user.friends.should have(3).items
    @user.friends.first.should be_kind_of(Scrobbler::User)
    @user.friends.first.name.should eql('lobsterclaw')
    @user.friends.first.realname.should eql('Laura Weiss')
    @user.friends.first.image(:small).should eql('http://userserve-ak.last.fm/serve/34/1733471.jpg')
    @user.friends.first.image(:medium).should eql('http://userserve-ak.last.fm/serve/64/1733471.jpg')
    @user.friends.first.image(:large).should eql('http://userserve-ak.last.fm/serve/126/1733471.jpg')
    @user.friends.first.url.should eql('http://www.last.fm/user/lobsterclaw')
  end
  
  it 'should be able to load additional information'
  
  it 'should be able to get its loved tracks' do
    @user.loved_tracks.should be_kind_of(Array)
    @user.loved_tracks.should have(49).items
    @user.loved_tracks.first.should be_kind_of(Scrobbler::Track)
    @user.loved_tracks.first.name.should eql('Early Mornin\' Stoned Pimp')
    @user.loved_tracks.first.mbid.should eql('')
    @user.loved_tracks.first.url.should eql('www.last.fm/music/Kid+Rock/_/Early+Mornin%27+Stoned+Pimp')
    @user.loved_tracks.first.date.should eql(Time.mktime(2009, 4, 28, 11, 38, 0))
    @user.loved_tracks.first.image(:small).should eql('http://userserve-ak.last.fm/serve/34s/3458313.jpg')
    @user.loved_tracks.first.image(:medium).should eql('http://userserve-ak.last.fm/serve/64s/3458313.jpg')
    @user.loved_tracks.first.image(:large).should eql('http://userserve-ak.last.fm/serve/126/3458313.jpg')
    @user.loved_tracks.first.artist.should be_kind_of(Scrobbler::Artist)
    @user.loved_tracks.first.artist.name.should eql('Kid Rock')
    @user.loved_tracks.first.artist.mbid.should eql('ad0ecd8b-805e-406e-82cb-5b00c3a3a29e')
    @user.loved_tracks.first.artist.url.should eql('http://www.last.fm/music/Kid+Rock')
  end
  
  it 'should be able to list the neighbours' do
    @user.should have(2).neighbours
    @user.neighbours.first.should be_kind_of(Scrobbler::User)
    @user.neighbours.first.name.should eql('Driotheri')
    @user.neighbours.first.url.should eql('http://www.last.fm/user/Driotheri')
    @user.neighbours.first.match.should eql('0.00027966260677204')
    @user.neighbours.first.image(:small).should eql('http://userserve-ak.last.fm/serve/34/6070771.jpg')
    @user.neighbours.first.image(:medium).should eql('http://userserve-ak.last.fm/serve/64/6070771.jpg')
    @user.neighbours.first.image(:large).should eql('http://userserve-ak.last.fm/serve/126/6070771.jpg')
  end
  
  it 'should be able to list the attened events'

  describe 'retrieving a users playlist' do

    before do
      @playlists = @user.playlists
      @firstplaylist = @playlists.first
    end

    it 'should return 4 playlists' do
      @playlists.size.should eql(4)
    end

    it 'should have the correct attributes in the first playlist' do
      #@firstplaylist.id.should eql(5606)
      require 'pp'
      pp @firstplaylist.id
      @firstplaylist.title.should eql('Misc gubbins')
      @firstplaylist.description.should eql('This is a misc test playlist with a few random tracks in it.')
      @firstplaylist.date.should eql(Time.mktime(2006, 11, 15, 13, 05, 48))
      @firstplaylist.size.should eql(10)
      @firstplaylist.duration.should eql(2771)
      @firstplaylist.streamable.should be_false
      @firstplaylist.creator.should eql('http://www.last.fm/user/RJ')
      @firstplaylist.url.should eql('http://www.last.fm/user/RJ/library/playlists/4bq_misc_gubbins')
      @firstplaylist.image(:small).should eql('http://userserve-ak.last.fm/serve/34/4218758.jpg')
      @firstplaylist.image(:medium).should eql('http://userserve-ak.last.fm/serve/64/4218758.jpg')
      @firstplaylist.image(:large).should eql('http://userserve-ak.last.fm/serve/126/4218758.jpg')
    end
  end
  
  
  it 'should be able to fetch the recent tracks' do
    @user.should have(10).recent_tracks
    @user.recent_tracks.first.should be_kind_of(Scrobbler::Track)
    @user.recent_tracks.first.name.should eql('Empty Arms')
    @user.recent_tracks.first.mbid.should eql('')
    @user.recent_tracks.first.url.should eql('http://www.last.fm/music/Stevie+Ray+Vaughan/_/Empty+Arms')
    @user.recent_tracks.first.date.should eql(Time.mktime(2009, 5, 6, 18, 16, 00))
    @user.recent_tracks.first.now_playing.should be_true
    @user.recent_tracks.first.streamable.should be_true
    @user.recent_tracks.first.artist.should be_kind_of(Scrobbler::Artist)
    @user.recent_tracks.first.artist.name.should eql('Stevie Ray Vaughan')
    @user.recent_tracks.first.artist.mbid.should eql('f5426431-f490-4678-ad44-a75c71097bb4')
    @user.recent_tracks.first.album.should be_kind_of(Scrobbler::Album)
    @user.recent_tracks.first.album.mbid.should eql('dfb4ba34-6d3f-4d88-848f-e8cc1e7c24d7')
    @user.recent_tracks.first.album.name.should eql('Sout To Soul')
    @user.recent_tracks.first.image(:small).should eql('http://userserve-ak.last.fm/serve/34s/4289298.jpg')
    @user.recent_tracks.first.image(:medium).should eql('http://userserve-ak.last.fm/serve/64s/4289298.jpg')
    @user.recent_tracks.first.image(:large).should eql('http://userserve-ak.last.fm/serve/126/4289298.jpg')
  end
  
  it 'should be able to list the recommended artists'
  
  it 'should be able to list the recommended events'
  
  it 'should be able to list the shouts'
  
  it 'should be able to list the top albums' do
    @user.should have(3).top_albums
    @user.top_albums.first.should be_kind_of(Scrobbler::Album)
    @user.top_albums.first.name.should eql('Slave To The Grid')
    @user.top_albums.first.mbid.should eql('')
    @user.top_albums.first.playcount.should eql(251)
    @user.top_albums.first.rank.should eql(1)
    @user.top_albums.first.artist.should be_kind_of(Scrobbler::Artist)
    @user.top_albums.first.artist.name.should eql('Skid Row')
    @user.top_albums.first.artist.mbid.should eql('6da0515e-a27d-449d-84cc-00713c38a140')
    @user.top_albums.first.url.should eql('http://www.last.fm/music/Skid+Row/Slave+To+The+Grid')
    @user.top_albums.first.image(:small).should eql('http://userserve-ak.last.fm/serve/34s/12621887.jpg')
    @user.top_albums.first.image(:medium).should eql('http://userserve-ak.last.fm/serve/64s/12621887.jpg')
    @user.top_albums.first.image(:large).should eql('http://userserve-ak.last.fm/serve/126/12621887.jpg')
  end
  
  it 'should be able to list the top artists' do 
    @user.should have(3).top_artists
    @user.top_artists.first.should be_kind_of(Scrobbler::Artist)
    first = @user.top_artists.first
    first.name.should eql('Dream Theater')
    first.mbid.should eql('28503ab7-8bf2-4666-a7bd-2644bfc7cb1d')
    first.playcount.should eql(1643)
    first.rank.should eql(1)
    first.url.should eql('http://www.last.fm/music/Dream+Theater')
    first.image(:small).should eql('http://userserve-ak.last.fm/serve/34/5535004.jpg')
    first.image(:medium).should eql('http://userserve-ak.last.fm/serve/64/5535004.jpg')
    first.image(:large).should eql('http://userserve-ak.last.fm/serve/126/5535004.jpg')
    first.streamable.should be_true
  end
  
  it 'should be able to list the top tags' do
    @user.should have(7).top_tags
    @user.top_tags.first.should be_kind_of Scrobbler::Tag
    first = @user.top_tags.first
    first.name.should eql 'rock'
    first.count.should eql 16
    first.url.should eql 'www.last.fm/tag/rock'
  end
  
  it 'should be able to list the top tracks' do
    @user.should have(3).top_tracks
    @user.top_tracks.first.should be_kind_of(Scrobbler::Track)
    first = @user.top_tracks.first
    first.name.should eql 'Learning to Live'
    first.mbid.should eql ''
    first.playcount.should eql 51
    first.rank.should eql 1
    first.url.should eql 'http://www.last.fm/music/Dream+Theater/_/Learning+to+Live'
    first.image(:small).should eql 'http://userserve-ak.last.fm/serve/34s/12620339.jpg'
    first.image(:medium).should eql 'http://userserve-ak.last.fm/serve/64s/12620339.jpg'
    first.image(:large).should eql 'http://userserve-ak.last.fm/serve/126/12620339.jpg'
    first.artist.should be_kind_of Scrobbler::Artist
    first.artist.name.should eql 'Dream Theater'
    first.artist.mbid.should eql '28503ab7-8bf2-4666-a7bd-2644bfc7cb1d'
    first.artist.url.should eql 'http://www.last.fm/music/Dream+Theater'
    first.streamable.should be_true
  end

  it 'should be able to get the weekly album chart' do
    @user.weekly_album_chart.should have(36).items
    first = @user.weekly_album_chart.first
    first.should be_kind_of Scrobbler::Album
    first.artist.should be_kind_of Scrobbler::Artist
    first.artist.name.should eql 'Nine Inch Nails'
    first.artist.mbid.should eql 'b7ffd2af-418f-4be2-bdd1-22f8b48613da'
    first.mbid.should eql 'df025315-4897-4759-ba77-d2cd09b5b4b6'
    first.name.should eql 'With Teeth'
    first.playcount.should eql 13
    first.rank.should eql 1    
    first.url.should eql 'http://www.last.fm/music/Nine+Inch+Nails/With+Teeth'
  end
  
  it 'should be able to get the weekly artist chart' do
    @user.weekly_artist_chart.should have(36).items
    first = @user.weekly_artist_chart.first
    first.should be_kind_of Scrobbler::Artist
    first.name.should eql 'Nine Inch Nails'
    first.mbid.should eql 'b7ffd2af-418f-4be2-bdd1-22f8b48613da'
    first.playcount.should eql 26
    first.rank.should eql 1
    first.url.should eql 'http://www.last.fm/music/Nine+Inch+Nails'
  end

  it 'should be able to get the weekly chart list'

  it 'should be able to get the weekly track chart' do
    @user.weekly_track_chart.should have(106).items
    first = @user.weekly_track_chart.first
    first.should be_kind_of Scrobbler::Track
    first.name.should eql 'Three Minute Warning'
    first.artist.should be_kind_of Scrobbler::Artist
    first.artist.name.should eql 'Liquid Tension Experiment'
    first.artist.mbid.should eql 'bc641be9-ca36-4c61-9394-5230433f6646'
    first.mbid.should eql ''
    first.playcount.should eql 5
    first.rank.should eql 1
    first.url.should eql 'www.last.fm/music/Liquid+Tension+Experiment/_/Three+Minute+Warning'
  end
  
  it 'should be able to leave a shout'
  
end
