class StatusCake::Error < StandardError
  attr_reader :json

  def initialize(json)
    @json = json
    super(json['Error'])
  end

  def err_no
    json['ErrNo'].to_i
  end
end
