require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'scrobbler'))

Scrobbler::Base::api_key = "..add..";

album = Scrobbler::Album.new('Some Hearts', :artist => 'Carrie Underwood', :include_info => true)

puts "Album: #{album.name}"
puts "Artist: #{album.artist}"
puts "Playcount: #{album.playcount}"
puts "URL: #{album.url}"
puts "Release Date: #{album.release_date.strftime('%m/%d/%Y')}"

puts
puts

puts "Tracks"
longest_track_name = album.tracks.collect(&:name).sort { |x, y| y.length <=> x.length }.first.length
puts "=" * longest_track_name
album.tracks.each { |t| puts t.name }
