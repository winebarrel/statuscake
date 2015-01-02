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
    '/API/Alerts/'               => :get,
    '/API/ContactGroups/Update/' => :put,
    '/API/ContactGroups/'        => :get,
    '/API/Tests/'                => :get,
    '/API/Tests/Details/'        => :get,
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

  APIs.each do |path, method|
    name = path.sub(%r|\A/API/|, '').sub(%r|/\z|, '').gsub('/', '_').downcase

    class_eval <<-EOS, __FILE__, __LINE__ + 1
      def #{name}(params = {})
        request(#{path.inspect}, #{method.inspect}, params)
      end
    EOS
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
