require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Scrobbler::Radio do

  before(:all) do 
    @radio = Scrobbler::Radio.new('lastfm://globaltags/disco')
  end
  
  it 'should know its station' do
    @radio.station.should eql('lastfm://globaltags/disco')
  end
  
  it 'should implement all methods from the Last.fm 2.0 API' do
    @radio.should respond_to(:tune)
    @radio.should respond_to(:playlist)
  end
  
  it 'should be able to tune in'
  
  it 'should be able to fetch the playlist'

end
