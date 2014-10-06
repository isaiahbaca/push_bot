module PushBot
  class Request
    def initialize(base)
      @base = base
    end

    def get(name, options)
      request(:get, name, options)
    end

    def post(name, options)
      request(:post, name, options)
    end

    def put(name, options)
      request(:put, name, options)
    end

    private

    def request(type, name, options)
      url = "https://api.pushbots.com/#{@base}"
      url << "/#{name}" if name

      request_options = {
        :method => type,
        :body => JSON.dump(options),
        :headers => {
          :'X-PushBots-AppID' => Config.config.id,
          :'X-PushBots-Secret' => Config.config.secret,
          :'Content-Type' => 'application/json'
        }
      }

      if type == :get
        request_options[:headers][:Token] = options[:token]
      end

      puts "Sending request:#{type} url:#{url} options:#{request_options.inspect}"

      request = Typhoeus::Request.new(url, request_options)

      Response.new(request)
    end
  end
end
