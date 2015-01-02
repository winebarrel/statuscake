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

  describe '/API/Alerts' do
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
        stub.get('/API/Alerts') do |env|
          expect(env.request_headers).to eq request_headers
          expect(env.params).to eq stringify_hash(params)
          [200, {'Content-Type' => 'application/json'}, JSON.dump(response)]
        end
      end

      expect(client.alerts(params)).to eq response
    end
  end

  describe '/API/ContactGroups/Update' do
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
        stub.put('/API/ContactGroups/Update') do |env|
          expect(env.request_headers).to eq form_request_headers
          expect(env.body).to eq URI.encode_www_form(params.sort)
          [200, {'Content-Type' => 'application/json'}, JSON.dump(response)]
        end
      end

      expect(client.contactgroups_update(params)).to eq response
    end
  end

  describe '/API/ContactGroups' do
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
        stub.get('/API/ContactGroups') do |env|
          expect(env.request_headers).to eq request_headers
          [200, {'Content-Type' => 'application/json'}, JSON.dump(response)]
        end
      end

      expect(client.contactgroups).to eq response
    end
  end

  describe '/API/Tests/Checks' do
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
        stub.get('/API/Tests/Checks') do |env|
          expect(env.request_headers).to eq request_headers
          expect(env.params).to eq stringify_hash(params)
          [200, {'Content-Type' => 'application/json'}, JSON.dump(response)]
        end
      end

      expect(client.tests_checks(params)).to eq response
    end
  end

  describe '/API/Tests/Periods' do
    let(:params) do
      {TestID: 241}
    end

    let(:response) do
      {"Start"=>"2013-02-24 16:01:46", "End"=>"0000-00-00 00:00:00", "Type"=>"Up"}
    end

    it do
      client = status_cake do |stub|
        stub.get('/API/Tests/Periods') do |env|
          expect(env.request_headers).to eq request_headers
          expect(env.params).to eq stringify_hash(params)
          [200, {'Content-Type' => 'application/json'}, JSON.dump(response)]
        end
      end

      expect(client.tests_periods(params)).to eq response
    end
  end

  describe '/API/Tests' do
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
        stub.get('/API/Tests') do |env|
          expect(env.request_headers).to eq request_headers
          [200, {'Content-Type' => 'application/json'}, JSON.dump(response)]
        end
      end

      expect(client.tests).to eq response
    end
  end

  describe '/API/Tests/Details' do
    let(:params) do
      {TestID: 241}
    end

    let(:response) do
      {"TestID"=>6735,
       "TestType"=>"HTTP",
       "Paused"=>false,
       "WebsiteName"=>"NL",
       "ContactGroup"=>"StatusCake Alerts",
       "ContactID"=>536,
       "Status"=>"Up",
       "Uptime"=>0,
       "CheckRate"=>1,
       "Timeout"=>40,
       "LogoImage"=>"",
       "WebsiteHost"=>"Various",
       "NodeLocations"=>["UK", "JP", "SG1", "SLC"],
       "FindString"=>"",
       "DoNotFind"=>false,
       "LastTested"=>"2013-01-20 14:38:18",
       "NextLocation"=>"USNY",
       "Processing"=>false,
       "ProcessingState"=>"Pretest",
       "ProcessingOn"=>"dalas.localdomain",
       "DownTimes"=>"0"}
    end

    it do
      client = status_cake do |stub|
        stub.get('/API/Tests/Details') do |env|
          expect(env.request_headers).to eq request_headers
          expect(env.params).to eq stringify_hash(params)
          [200, {'Content-Type' => 'application/json'}, JSON.dump(response)]
        end
      end

      expect(client.tests_details(params)).to eq response
    end
  end

  describe '/API/Tests/Details (delete)' do
    let(:params) do
      {TestID: 241}
    end

    let(:response) do
      {"TestID"=>6735,
       "Affected"=>1,
       "Success"=>true,
       "Message"=>"This Check Has Been Deleted. It can not be recovered."}
    end

    it do
      client = status_cake do |stub|
        stub.delete('/API/Tests/Details') do |env|
          expect(env.request_headers).to eq request_headers
          expect(env.params).to eq stringify_hash(params)
          [200, {'Content-Type' => 'application/json'}, JSON.dump(response)]
        end
      end

      expect(client.tests_details(params.merge(method: :delete))).to eq response
    end
  end

  describe '/API/Tests/Update' do
    let(:params) do
      {
        WebsiteName: 'Example Domain',
        WebsiteURL:  'http://example.com',
        CheckRate:   300,
        TestType:    :HTTP,
      }
    end

    let(:response) do
      {"Success"=>true,
       "Message"=>"Test Inserted",
       "Issues"=>nil,
       "Data"=>
        {"WebsiteName"=>"Example Domain",
         "WebsiteURL"=>"http://example.com",
         "CheckRate"=>"300",
         "TestType"=>"HTTP",
         "Client"=>"12345"},
       "InsertID"=>7555}
    end

    it do
      client = status_cake do |stub|
        stub.put('/API/Tests/Update') do |env|
          expect(env.request_headers).to eq form_request_headers
          expect(env.body).to eq URI.encode_www_form(params.sort)
          [200, {'Content-Type' => 'application/json'}, JSON.dump(response)]
        end
      end

      expect(client.tests_update(params)).to eq response
    end
  end

  describe '/API/Locations/json' do
    describe '#locations_json' do
      let(:response) do
        {"1"=>{"guid"=>"8", "servercode"=>"UK", "title"=>"England, London", "ip"=>"37.122.208.79", "countryiso"=>"GB", "status"=>"Up"}, "2"=>{"guid"=>"3", "servercode"=>"JP", "title"=>"Japan, Tyoko", "ip"=>"50.31.240.172", "countryiso"=>"JP", "status"=>"Up"}, "3"=>{"guid"=>"4", "servercode"=>"SG1", "title"=>"Singapore", "ip"=>"199.195.193.112", "countryiso"=>"SG", "status"=>"Up"}, "4"=>{"guid"=>"5", "servercode"=>"US", "title"=>"United States, San Jose", "ip"=>"199.195.192.240", "countryiso"=>"US", "status"=>"Up"}, "5"=>{"guid"=>"12", "servercode"=>"USNY", "title"=>"United States, New York", "ip"=>"216.155.131.57", "countryiso"=>"US", "status"=>"Up"}, "6"=>{"guid"=>"7", "servercode"=>"NE1", "title"=>"Netherlands, Amsterdam", "ip"=>"31.131.20.205", "countryiso"=>"NL", "status"=>"Up"}, "7"=>{"guid"=>"11", "servercode"=>"UK1", "title"=>"England, Manchester", "ip"=>"37.157.246.146", "countryiso"=>"GB", "status"=>"Up"}, "8"=>{"guid"=>"13", "servercode"=>"AUS", "title"=>"Australia, Sydney", "ip"=>"119.252.188.216", "countryiso"=>"AU", "status"=>"Up"}, "9"=>{"guid"=>"14", "servercode"=>"USDA", "title"=>"United States, Dallas", "ip"=>"173.255.139.226", "countryiso"=>"US", "status"=>"Up"}, "10"=>{"guid"=>"15", "servercode"=>"SLC", "title"=>"United States, Salt Lake City", "ip"=>"68.169.44.43", "countryiso"=>"US", "status"=>"Up"}, "11"=>{"guid"=>"16", "servercode"=>"UKCon", "title"=>"UK Robin", "ip"=>"109.123.82.244", "countryiso"=>"GB", "status"=>"Up"}, "12"=>{"guid"=>"17", "servercode"=>"SA", "title"=>"South Africa, Johannesburg", "ip"=>"41.86.108.228", "countryiso"=>"SA", "status"=>"Up"}, "13"=>{"guid"=>"18", "servercode"=>"DE", "title"=>"Germany, Berlin", "ip"=>"5.45.179.103", "countryiso"=>"DE", "status"=>"Up"}, "14"=>{"guid"=>"19", "servercode"=>"CA", "title"=>"Canada, Montreal", "ip"=>"199.167.128.80", "countryiso"=>"CA", "status"=>"Up"}, "15"=>{"guid"=>"20", "servercode"=>"FR", "title"=>"France, Roubaix", "ip"=>"37.59.151.154", "countryiso"=>"FR", "status"=>"Up"}, "16"=>{"guid"=>"21", "servercode"=>"NY2", "title"=>"United States, New York #2", "ip"=>"199.167.198.78", "countryiso"=>"US", "status"=>"Up"}, "17"=>{"guid"=>"22", "servercode"=>"NL2", "title"=>"Netherlands, Amsterdam #2", "ip"=>"176.56.230.59", "countryiso"=>"NL", "status"=>"Up"}, "18"=>{"guid"=>"23", "servercode"=>"NL3", "title"=>"Netherlands, Amsterdam #3", "ip"=>"198.144.121.195", "countryiso"=>"NL", "status"=>"Up"}, "19"=>{"guid"=>"24", "servercode"=>"SE", "title"=>"Sweden, Stockholm", "ip"=>"46.246.93.131", "countryiso"=>"SE", "status"=>"Up"}}
      end

      it do
        client = status_cake do |stub|
          stub.get('/API/Locations/json') do |env|
            expect(env.request_headers).to eq request_headers
            [200, {'Content-Type' => 'application/json'}, JSON.dump(response)]
          end
        end

        expect(client.locations_json).to eq response
      end
    end

    describe '#locations' do
      let(:response) do
        {"1"=>{"guid"=>"8", "servercode"=>"UK", "title"=>"England, London", "ip"=>"37.122.208.79", "countryiso"=>"GB", "status"=>"Up"}, "2"=>{"guid"=>"3", "servercode"=>"JP", "title"=>"Japan, Tyoko", "ip"=>"50.31.240.172", "countryiso"=>"JP", "status"=>"Up"}, "3"=>{"guid"=>"4", "servercode"=>"SG1", "title"=>"Singapore", "ip"=>"199.195.193.112", "countryiso"=>"SG", "status"=>"Up"}, "4"=>{"guid"=>"5", "servercode"=>"US", "title"=>"United States, San Jose", "ip"=>"199.195.192.240", "countryiso"=>"US", "status"=>"Up"}, "5"=>{"guid"=>"12", "servercode"=>"USNY", "title"=>"United States, New York", "ip"=>"216.155.131.57", "countryiso"=>"US", "status"=>"Up"}, "6"=>{"guid"=>"7", "servercode"=>"NE1", "title"=>"Netherlands, Amsterdam", "ip"=>"31.131.20.205", "countryiso"=>"NL", "status"=>"Up"}, "7"=>{"guid"=>"11", "servercode"=>"UK1", "title"=>"England, Manchester", "ip"=>"37.157.246.146", "countryiso"=>"GB", "status"=>"Up"}, "8"=>{"guid"=>"13", "servercode"=>"AUS", "title"=>"Australia, Sydney", "ip"=>"119.252.188.216", "countryiso"=>"AU", "status"=>"Up"}, "9"=>{"guid"=>"14", "servercode"=>"USDA", "title"=>"United States, Dallas", "ip"=>"173.255.139.226", "countryiso"=>"US", "status"=>"Up"}, "10"=>{"guid"=>"15", "servercode"=>"SLC", "title"=>"United States, Salt Lake City", "ip"=>"68.169.44.43", "countryiso"=>"US", "status"=>"Up"}, "11"=>{"guid"=>"16", "servercode"=>"UKCon", "title"=>"UK Robin", "ip"=>"109.123.82.244", "countryiso"=>"GB", "status"=>"Up"}, "12"=>{"guid"=>"17", "servercode"=>"SA", "title"=>"South Africa, Johannesburg", "ip"=>"41.86.108.228", "countryiso"=>"SA", "status"=>"Up"}, "13"=>{"guid"=>"18", "servercode"=>"DE", "title"=>"Germany, Berlin", "ip"=>"5.45.179.103", "countryiso"=>"DE", "status"=>"Up"}, "14"=>{"guid"=>"19", "servercode"=>"CA", "title"=>"Canada, Montreal", "ip"=>"199.167.128.80", "countryiso"=>"CA", "status"=>"Up"}, "15"=>{"guid"=>"20", "servercode"=>"FR", "title"=>"France, Roubaix", "ip"=>"37.59.151.154", "countryiso"=>"FR", "status"=>"Up"}, "16"=>{"guid"=>"21", "servercode"=>"NY2", "title"=>"United States, New York #2", "ip"=>"199.167.198.78", "countryiso"=>"US", "status"=>"Up"}, "17"=>{"guid"=>"22", "servercode"=>"NL2", "title"=>"Netherlands, Amsterdam #2", "ip"=>"176.56.230.59", "countryiso"=>"NL", "status"=>"Up"}, "18"=>{"guid"=>"23", "servercode"=>"NL3", "title"=>"Netherlands, Amsterdam #3", "ip"=>"198.144.121.195", "countryiso"=>"NL", "status"=>"Up"}, "19"=>{"guid"=>"24", "servercode"=>"SE", "title"=>"Sweden, Stockholm", "ip"=>"46.246.93.131", "countryiso"=>"SE", "status"=>"Up"}}
      end

      it do
        client = status_cake do |stub|
          stub.get('/API/Locations/json') do |env|
            expect(env.request_headers).to eq request_headers
            [200, {'Content-Type' => 'application/json'}, JSON.dump(response)]
          end
        end

        expect(client.locations).to eq response
      end
    end
  end

  describe '/API/Locations/txt' do
    let(:response) do
      "37.122.208.79\n50.31.240.172\n199.195.193.112\n199.195.192.240\n216.155.131.57\n31.131.20.205\n37.157.246.146\n119.252.188.216\n173.255.139.226\n68.169.44.43\n109.123.82.244\n41.86.108.228\n5.45.179.103\n199.167.128.80\n37.59.151.154\n199.167.198.78\n176.56.230.59\n198.144.121.195\n46.246.93.131"
    end

    it do
      client = status_cake do |stub|
        stub.get('/API/Locations/txt') do |env|
          expect(env.request_headers).to eq request_headers
          [200, {'Content-Type' => 'text/plain'}, response]
        end
      end

      expect(client.locations_txt).to eq response
    end
  end

  describe '/API/Locations/xml' do
    let(:response) do
      "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<rss version=\"2.0\"\nxmlns:atom=\"https://www.w3.org/2005/Atom\">\n<channel>\n    <title>Test Locations</title>\n    <link>https://www.statuscake.com</link>\n    <description>These are the test locations and IPs. You can use the IP numbers in your firewall rules</description>\n    <language>en</language><item>\n                <guid isPermaLink=\"false\">Location_8</guid>\n                <title>England, London</title>\n                <ip>37.122.208.79</ip>\n                <countryiso>GB</countryiso>\n                <status>Up</status>\n</item><item>\n                <guid isPermaLink=\"false\">Location_3</guid>\n                <title>Japan, Tyoko</title>\n                <ip>50.31.240.172</ip>\n                <countryiso>JP</countryiso>\n                <status>Up</status>\n</item><item>\n                <guid isPermaLink=\"false\">Location_4</guid>\n                <title>Singapore</title>\n                <ip>199.195.193.112</ip>\n                <countryiso>SG</countryiso>\n                <status>Up</status>\n</item><item>\n                <guid isPermaLink=\"false\">Location_5</guid>\n                <title>United States, San Jose</title>\n                <ip>199.195.192.240</ip>\n                <countryiso>US</countryiso>\n                <status>Up</status>\n</item><item>\n                <guid isPermaLink=\"false\">Location_12</guid>\n                <title>United States, New York</title>\n                <ip>216.155.131.57</ip>\n                <countryiso>US</countryiso>\n                <status>Up</status>\n</item><item>\n                <guid isPermaLink=\"false\">Location_7</guid>\n                <title>Netherlands, Amsterdam</title>\n                <ip>31.131.20.205</ip>\n                <countryiso>NL</countryiso>\n                <status>Up</status>\n</item><item>\n                <guid isPermaLink=\"false\">Location_11</guid>\n                <title>England, Manchester</title>\n                <ip>37.157.246.146</ip>\n                <countryiso>GB</countryiso>\n                <status>Up</status>\n</item><item                <guid isPermaLink=\"false\">Location_13</guid>\n                <title>Australia, Sydney</title>\n                <ip>119.252.188.216</ip>\n                <countryiso>AU</countryiso>\n                <status>Up</status>\n</item><item>\n                <guid isPermaLink=\"false\">Location_14</guid>\n                <title>United States, Dallas</title>\n                <ip>173.255.139.226</ip>\n                <countryiso>US</countryiso>\n                <status>Up</status>\n</item><item>\n                <guid isPermaLink=\"false\">Location_15</guid>\n                <title>United States, Salt Lake City</title>\n                <ip>68.169.44.43</ip>\n                <countryiso>US</countryiso>\n                <status>Up</status>\n</item><item>\n                <guid isPermaLink=\"false\">Location_16</guid>\n                <title>UK Robin</title>\n                <ip>109.123.82.244</ip>\n                <countryiso>GB</countryiso>\n                <status>Up</status>\n</item><item>\n                <guid isPermaLink=\"false\"n_17</guid>\n                <title>South Africa, Johannesburg</title>\n                <ip>41.86.108.228</ip>\n                <countryiso>SA</countryiso>\n                <status>Up</status>\n</item><item>\n                <guid isPermaLink=\"false\">Location_18</guid>\n                <title>Germany, Berlin</title>\n                <ip>5.45.179.103</ip>\n                <countryiso>DE</countryiso>\n                <status>Up</status>\n</item><item>\n                <guid isPermaLink=\"false\">Location_19</guid>\n                <title>Canada, Montreal</title>\n                <ip>199.167.128.80</ip>\n                <countryiso>CA</countryiso>\n                <status>Up</status>\n</item><item>\n                <guid isPermaLink=\"false\">Location_20</guid>\n                <title>France, Roubaix</title>\n                <ip>37.59.151.154</ip>\n                <countryiso>FR</countryiso>\n                <status>Up</status>\n</item><item>\n                <guid isPermaLink=\"false\">Location_21</guid>\n                <title>United States                <ip>199.167.198.78</ip>\n                <countryiso>US</countryiso>\n                <status>Up</status>\n</item><item>\n                <guid isPermaLink=\"false\">Location_22</guid>\n                <title>Netherlands, Amsterdam #2</title>\n                <ip>176.56.230.59</ip>\n                <countryiso>NL</countryiso>\n                <status>Up</status>\n</item><item>\n                <guid isPermaLink=\"false\">Location_23</guid>\n                <title>Netherlands, Amsterdam #3</title>\n                <ip>198.144.121.195</ip>\n                <countryiso>NL</countryiso>\n                <status>Up</status>\n</item><item>\n                <guid isPermaLink=\"false\">Location_24</guid>\n                <title>Sweden, Stockholm</title>\n                <ip>46.246.93.131</ip>\n                <countryiso>SE</countryiso>\n                <status>Up</status>\n</item></channel>\n     </rss>"
    end

    it do
      client = status_cake do |stub|
        stub.get('/API/Locations/xml') do |env|
          expect(env.request_headers).to eq request_headers
          [200, {'Content-Type' => 'text/xml'}, response]
        end
      end

      expect(client.locations_xml).to eq response
    end
  end

  context 'when error happen' do
    let(:response) do
      {"ErrNo"=>1, "Error"=>"REQUEST[TestID] provided not linked to this account"}
    end

    it do
      client = status_cake do |stub|
        stub.get('/API/Alerts') do |env|
          expect(env.request_headers).to eq request_headers
          [200, {'Content-Type' => 'application/json'}, JSON.dump(response)]
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
        stub.get('/API/Alerts') do |env|
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
