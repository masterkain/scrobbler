require 'digest/md5'

$KCODE = 'u'

include LibXML

module Scrobbler

  API_URL     = 'http://ws.audioscrobbler.com/'

  class Base
    def Base.api_key=(api_key)
      @@api_key = api_key
    end

    def Base.secret=(secret)
      @@secret = secret
    end

    def Base.connection
      @connection ||= REST::Connection.new(API_URL)
    end

    def Base.sanitize(param)
      URI.escape(param.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end

    def Base.get(api_method, parent, element, parameters = {})
      scrobbler_class = "scrobbler/#{element.to_s}".camelize.constantize
      doc = request(api_method, parameters)
      elements = []
      doc.root.children.each do |child|
        next unless child.name == parent.to_s
        child.children.each do |child2|
          next unless child2.name == element.to_s
          elements << scrobbler_class.new_from_libxml(child2)
        end
      end
      elements
    end

    def Base.post_request(api_method, parameters = {}, request_method = 'get')
      Base.request(api_method, parameters, 'post')
    end

    def Base.request(api_method, parameters = {}, request_method = 'get')
      parameters = {:signed => false}.merge(parameters)
      parameters['api_key'] = @@api_key
      parameters['method'] = api_method.to_s
      paramlist = []
      # Check if we want a signed call and pop :signed
      if parameters.delete :signed
        #1: Sort alphabetically
        params = parameters.sort{|a,b| a[0].to_s<=>b[0].to_s}
        #2: concat them into one string
        str = params.join('')
        #3: Append secret
        str = str + @@secret
        #4: Make a md5 hash
        md5 = Digest::MD5.hexdigest(str)
        params << [:api_sig, md5]
        params.each do |a|
          paramlist << "#{sanitize(a[0])}=#{sanitize(a[1])}"
        end
      else
        parameters.each do |key, value|
          paramlist << "#{sanitize(key)}=#{sanitize(value)}"
        end
      end
      url = '/2.0/?' + paramlist.join('&')
      XML::Document.string(self.connection.send(request_method,url))
    end


    private

      def Base.mixins(*args)
        args.each do |arg|
          if arg == :image
            extend Scrobbler::ImageClassFuncs
            include Scrobbler::ImageObjectFuncs
          elsif arg == :streamable
            attr_reader :streamable
            extend StreamableClassFuncs
            include StreamableObjectFuncs
          else
            raise ArgumentError, "#{arg} is not a known mixin"
          end
        end
      end

      def populate_data(data = {})
        data.each do |key, value|
          instance_variable_set("@#{key.to_s}", value)
        end
      end

      def get_response(api_method, instance_name, parent, element, params, force=false)
        if instance_variable_get("@#{instance_name}").nil? || force
          instance_variable_set("@#{instance_name}", Base.get(api_method, parent, element, params))
        end
        instance_variable_get("@#{instance_name}")
      end
  end # class Base
end # module Scrobbler
