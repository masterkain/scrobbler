describe Scrobbler::Scrobble do
  before do
    Scrobbler::Scrobble.client_id = 'spec'
    @user = Scrobbler::User.new('TestUser')
    @session = Scrobbler::Session.new(:key => 'testKey', :name => 'testName', :subscriber => true)
    @scrobble = Scrobbler::Scrobble.new(:handshake_on_init => false, :user => @user, :session => @session)
  end
  
  describe 'should implement the method' do
    [:submit, :now_playing, :handshake].each do |method_name|
      it "'#{method_name}'" do
        @scrobble.should respond_to(method_name)
      end
    end
  end
  
  describe 'doing initialization should require' do
    it 'a session' do
      lambda {
        Scrobbler::Scrobble.new(:session => nil, :user => @user)
      }.should raise_error(ArgumentError)
    end
    
    it 'a user' do
      lambda {
        Scrobbler::Scrobble.new(:session => @session, :user => nil)
      }.should raise_error(ArgumentError)
    end
  end
  
  describe 'handshaking should provide' do
    it 'a session id'
    it 'a now-playing url'
    it 'a submisson url'
  end
  
  describe 'handshaking could fail with' do
    it BadAuthError 
    it BadTimeError
    it RequestFailedError
    it ClientBannedError
  end
  
  describe 'now_playing should work with' do
    it 'just track and artist'
    it 'additionally the duration'
    it 'additionally the album name'
    it 'additionally the track\'s MusicBrainz id'
  end
  
  describe 'now_playing could fail with' do
    it BadSessionError
  end

end
