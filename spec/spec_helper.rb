require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
end

require File.expand_path("../../lib/tatooine", __FILE__)

require "rspec"
require "vcr"
require "webmock/rspec"

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  c.hook_into :webmock
end

RSpec.configure do |config|
  config.include WebMock::API
end


