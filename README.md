# StatusCake

It is a [StatusCake](https://www.statuscake.com/) API client library.

[![Gem Version](https://badge.fury.io/rb/statuscake.svg)](http://badge.fury.io/rb/statuscake)
[![Build Status](https://travis-ci.org/winebarrel/statuscake.svg?branch=master)](https://travis-ci.org/winebarrel/statuscake)

It is a thin library, and methods are [dynamically generated](https://github.com/winebarrel/statuscake/blob/a5f692fa8bf02a16f7a98e1c7d05f2110e51dbd1/lib/statuscake/client.rb#L56).

```ruby
path.sub(%r|\A/API/|, '').gsub('/', '_').downcase
# "/API/Tests/Details" => "def tests_details"
```

It supports the following API:

* /API/Alerts
* /API/ContactGroups/Update
* /API/ContactGroups
* /API/Tests/Checks
* /API/Tests/Periods
* /API/Tests
* /API/Tests/Details
* /API/Tests/Update
* /API/Locations/json
* /API/Locations/txt
* /API/Locations/xml
* /API/Auth

see [StatusCake::Client::APIs](https://github.com/winebarrel/statuscake/blob/a5f692fa8bf02a16f7a98e1c7d05f2110e51dbd1/lib/statuscake/client.rb#L15).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'statuscake'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install statuscake

## Usage

```ruby
require 'statuscake'

client = StatusCake::Client.new(API: 'l6OxVJilcD2cETMoNRvn', Username: 'StatusCake')

client.tests_details(TestID: 241)
#=> {"TestID"=>241,
#    "TestType"=>"HTTP",
#    "Paused"=>false,
#    "Affected"=>1,
#    ...

client.tests_update(
  WebsiteName: 'Example Domain',
  WebsiteURL:  'http://example.com',
  CheckRate:   300,
  TestType:    :HTTP)
#=> {"Success"=>true,
#    "Message"=>"Test Inserted",
#    "Issues"=>nil,
#    "Data"=>
#     {"WebsiteName"=>"Example Domain",
#     ...
```

### Deleting a Test

```ruby
client.tests_details(
  method: :delete,
  TestID: 241)
#=> {"TestID"=>6735,
#    "Affected"=>1,
#    "Success"=>true,
#    "Message"=>"This Check Has Been Deleted. It can not be recovered."}

```

I think this method call is strange.

This is because [the original API](https://www.statuscake.com/api/Tests/Deleting%20a%20Test.md) is strange.

## Test

```ruby
bundle install
bundle exec rake
```

## StatusCake API reference

* https://www.statuscake.com/api/index.md
