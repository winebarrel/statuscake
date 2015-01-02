describe StatusCake::Client do
  let(:request_headers) do
    {"User-Agent"=>StatusCake::Client::USER_AGENT,
     "Api"=>TEST_API_KEY,
     "Username"=>TEST_USERNAME}
  end

  describe '/API/Tests/' do
    let(:response) do
      [{"TestID"=>28110,
        "Paused"=>false,
        "TestType"=>"HTTP",
        "WebsiteName"=>"Test Period Data",
        "ContactGroup"=>nil,
        "ContactID"=>0,
        "Status"=>"Up",
        "Uptime"=>100}]
    end

    it do
      client = status_cake do |stub|
        stub.get('/API/Tests/') do |env|
          expect(env.request_headers).to eq request_headers
          [200, {'Content-Type' => 'json'}, JSON.dump(response)]
        end
      end

      expect(client.tests).to eq response
    end
  end
end
