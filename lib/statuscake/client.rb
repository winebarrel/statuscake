class StatusCake::Client
  ENDPOINT = 'https://www.statuscake.com'
  USER_AGENT = "Ruby StatusCake Client #{StatusCake::VERSION}"

  DEFAULT_ADAPTERS = [
    Faraday::Adapter::NetHttp,
    Faraday::Adapter::Test
  ]

  OPTIONS = [
    :API,
    :Username,
  ]

  APIs = {
    '/API/Alerts'               => {:method => :get},
    '/API/ContactGroups/Update' => {:method => :put},
    '/API/ContactGroups'        => {:method => :get},
    '/API/Tests/Checks'         => {:method => :get},
    '/API/Tests/Periods'        => {:method => :get},
    '/API/Tests'                => {:method => :get},
    '/API/Tests/Details'        => {:method => :get},
    # Delete test when HTTP method is "DELETE"
    # see https://www.statuscake.com/api/Tests/Deleting%20a%20Test.md
    '/API/Tests/Update'         => {:method => :put},
    '/API/Locations/json'       => {:method => :get, :alias => :locations},
    '/API/Locations/txt'        => {:method => :get},
    '/API/Locations/xml'        => {:method => :get},
  }

  def initialize(options)
    @options = {}

    OPTIONS.each do |key|
      @options[key] = options.delete(key)
    end

    options[:url] ||= ENDPOINT

    @conn = Faraday.new(options) do |faraday|
      faraday.request  :url_encoded
      faraday.response :json, :content_type => /\bjson$/
      faraday.response :raise_error

      yield(faraday) if block_given?

      unless DEFAULT_ADAPTERS.any? {|i| faraday.builder.handlers.include?(i) }
        faraday.adapter Faraday.default_adapter
      end
    end

    @conn.headers[:user_agent] = USER_AGENT
  end

  APIs.each do |path, attrs|
    names = [path.sub(%r|\A/API/|, '').gsub('/', '_').downcase]
    names << attrs[:alias] if attrs.has_key?(:alias)
    method = attrs[:method]

    names.each do |name|
      class_eval <<-EOS, __FILE__, __LINE__ + 1
        def #{name}(params = {})
          method = params.delete(:method) || #{method.inspect}
          request(#{path.inspect}, method, params)
        end
      EOS
    end
  end

  private

  def request(path, method, params = {})
    response = @conn.send(method) do |req|
      req.url path

      case method
      when :get, :delete
        req.params = params
      when :post, :put
        req.body = params
      else
        raise 'must not happen'
      end

      req.headers[:API] = @options[:API]
      req.headers[:Username] = @options[:Username]
      yield(req) if block_given?
    end

    json = response.body
    validate_response(json)
    json
  end

  def validate_response(json)
    if json.kind_of?(Hash) and json.has_key?('ErrNo')
      raise StatusCake::Error.new(json)
    end
  end
end
