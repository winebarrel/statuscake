describe StatusCake::Client do
  let(:request_headers) do
    {
      'User-Agent' => StatusCake::Client::USER_AGENT,
      'Api'        => TEST_API_KEY,
      'Username'   => TEST_USERNAME,
    }
  end

  let(:form_request_headers) do
    request_headers.merge(
      'Content-Type' => 'application/x-www-form-urlencoded'
    )
  end

  describe '/API/Alerts/' do
    let(:params) do
      {TestID: 241}
    end

    let(:response) do
      [{"Triggered"=>"2013-02-25 14:42:41",
        "StatusCode"=>0,
        "Unix"=>1361803361,
        "Status"=>"Down",
        "TestID"=>26324}]
    end

    it do
      client = status_cake do |stub|
        stub.get('/API/Alerts/') do |env|
          expect(env.request_headers).to eq request_headers
          expect(env.params).to eq stringify_hash(params)
          [200, {'Content-Type' => 'json'}, JSON.dump(response)]
        end
      end

      expect(client.alerts(params)).to eq response
    end
  end

  describe '/API/ContactGroups/Update/' do
    let(:params) do
      {GroupName: 'my group', Email: 'alice@example.com'}
    end

    let(:response) do
      {"Success"=>true,
       "Message"=>"Test Inserted",
       "Issues"=>[],
       "Data"=>
        {"Email"=>"alice@example.com", "GroupName"=>"my group", "Client"=>"54321"},
       "InsertID"=>12345}
    end

    it do
      client = status_cake do |stub|
        stub.put('/API/ContactGroups/Update/') do |env|
          expect(env.request_headers).to eq form_request_headers
          expect(env.body).to eq URI.encode_www_form(params.sort)
          [200, {'Content-Type' => 'json'}, JSON.dump(response)]
        end
      end

      expect(client.contactgroups_update(params)).to eq response
    end
  end

  describe '/API/ContactGroups/' do
    let(:response) do
      [{"GroupName"=>"Pushover Test",
        "Emails"=>["team@trafficcake.com"],
        "Mobiles"=>[],
        "Boxcar"=>"",
        "Pushover"=>"gZh7mBkRIH4CsxWDwvkLBwlEZpxfpZ",
        "ContactID"=>5,
        "PingURL"=>"",
        "DesktopAlert"=>1}]
    end

    it do
      client = status_cake do |stub|
        stub.get('/API/ContactGroups/') do |env|
          expect(env.request_headers).to eq request_headers
          [200, {'Content-Type' => 'json'}, JSON.dump(response)]
        end
      end

      expect(client.contactgroups).to eq response
    end
  end

  describe '/API/Tests/Checks/' do
    let(:params) do
      {TestID: 241}
    end

    let(:response) do
      {"3986660001"=>{"Location"=>"WADA3", "Time"=>1413285656, "Status"=>200},
       "3027990001"=>{"Location"=>"DOUK2", "Time"=>1413285239, "Status"=>200},
       "3322390001"=>{"Location"=>"UK50", "Time"=>1413285124, "Status"=>200}}
    end

    it do
      client = status_cake do |stub|
        stub.get('/API/Tests/Checks/') do |env|
          expect(env.request_headers).to eq request_headers
          expect(env.params).to eq stringify_hash(params)
          [200, {'Content-Type' => 'json'}, JSON.dump(response)]
        end
      end

      expect(client.tests_checks(params)).to eq response
    end
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

  context 'when error happen' do
    let(:response) do
      {"ErrNo"=>1, "Error"=>"REQUEST[TestID] provided not linked to this account"}
    end

    it do
      client = status_cake do |stub|
        stub.get('/API/Alerts/') do |env|
          expect(env.request_headers).to eq request_headers
          [200, {'Content-Type' => 'json'}, JSON.dump(response)]
        end
      end

      expect {
        client.alerts
      }.to raise_error(StatusCake::Error, 'REQUEST[TestID] provided not linked to this account')
    end
  end

  context 'when status is not 200' do
    it do
      client = status_cake do |stub|
        stub.get('/API/Alerts/') do |env|
          expect(env.request_headers).to eq request_headers
          [500, {}, 'Internal Server Error']
        end
      end

      expect {
        client.alerts
      }.to raise_error
    end
  end
end
