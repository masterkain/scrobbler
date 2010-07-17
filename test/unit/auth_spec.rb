require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Scrobbler::Auth do

  before(:all) do 
    @auth = Scrobbler::Auth.new('user')
  end
  
  it 'should implement all methods from the Last.fm 2.0 API' do
    @auth.should respond_to(:mobile_session)
    @auth.should respond_to(:session)
    @auth.should respond_to(:token)
    @auth.should respond_to(:websession)
  end
  
  it 'should be able to start a mobile session'
  
  it 'should be able to fetch a session key' do
    session = @auth.session('test123token')
    session.should be_kind_of(Scrobbler::Session)
    session.name.should eql('MyLastFMUsername')
    session.key.should eql('d580d57f32848f5dcf574d1ce18d78b2')
    session.subscriber.should be_false
  end
  
  it 'should be able to fetch a request token' do
    @auth.token.should eql('0e6af5cd2fff6b314994af5b0c58ecc1')
  end
  
  it 'should be able to start a web session'
  
  it 'should be able to get a url for authenticate this service' do
    @auth.url.should eql('http://www.last.fm/api/auth/?api_key=foo123&token=0e6af5cd2fff6b314994af5b0c58ecc1')
  end

end
