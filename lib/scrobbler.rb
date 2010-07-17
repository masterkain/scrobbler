%w{uri rubygems libxml active_support}.each { |x| require x }
require 'digest/md5'

$: << File.expand_path(File.dirname(__FILE__))

# Load base class
require 'scrobbler/base'

# Load helper modules
require 'scrobbler/helper/image'
require 'scrobbler/helper/streamable'

require 'scrobbler/album'
require 'scrobbler/artist'
require 'scrobbler/event'
require 'scrobbler/shout'
require 'scrobbler/venue'
require 'scrobbler/geo'
require 'scrobbler/user'
require 'scrobbler/session'
require 'scrobbler/tag'
require 'scrobbler/track'

require 'scrobbler/auth'
require 'scrobbler/library'
require 'scrobbler/playlist'
require 'scrobbler/radio'

require 'scrobbler/simpleauth'
require 'scrobbler/scrobble'
require 'scrobbler/playing'

require 'scrobbler/rest'

# Added by kain.
require 'scrobbler/webscrobble'