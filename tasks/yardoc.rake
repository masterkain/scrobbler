begin
  require 'yard'
  YARD::Rake::YardocTask.new do |t|
    t.files   = ['lib/**/*.rb']   # optional
  end
rescue LoadError
  puts "YARD not available. Install it with: sudo gem install yard"
end
