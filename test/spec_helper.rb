require File.dirname(__FILE__) + '/../lib/scrobbler'
require File.dirname(__FILE__) + '/mocks/rest'

# To test the 2.0 API, we do not need a valid key but one must be set
Scrobbler::Base.api_key = 'foo123'
Scrobbler::Base.secret = 'bar456'

