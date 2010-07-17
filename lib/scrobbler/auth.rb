#--
# Copyright (c) 2010 iCoreTech Labs.
#
# This file is part of the AudioBox.fm project.
#++

# Author::    Claudio Poli (mailto:claudio@icoretech.org)
# Copyright:: Copyright (c) 2010 iCoreTech Labs
# License::   iCoreTech Labs Private License

module Scrobbler
  class Auth < Base

    def initialize(args = {})
    end

    def session(token)
      doc = Base.request('auth.getsession', :signed => true, :token => token)
      asession = {}
      doc.root.children.each do |child1|
        next unless child1.name == 'session'
        child1.children.each do |child2|
          if child2.name == 'name'
            asession[:name] = child2.content
          elsif child2.name == 'key'
            asession[:key] = child2.content
          elsif child2.name == 'subscriber'
            asession[:subscriber] = true if child2.content == '1'
            asession[:subscriber] = false unless child2.content == '1'
          end
        end
      end
      Scrobbler::Session.new(asession)
    end

    def token
      doc = Base.request('auth.gettoken', :signed => true)
      stoken = ''
      doc.root.children.each do |child|
        next unless child.name == 'token'
        stoken = child.content
      end
      stoken
    end

    def url(options={})
      options[:token] = token if options[:token].nil?
      options[:api_key] = @@api_key
      "http://www.last.fm/api/auth/?api_key=#{options[:api_key]}&token=#{options[:token]}"
    end

  end
end
