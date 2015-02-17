require "./spec/spec_helper"

describe "API errors" do
  {
    400 => Tatooine::BadRequest,
    404 => Tatooine::NotFound,
    500 => Tatooine::InternalServerError,
    502 => Tatooine::BadGateway,
    503 => Tatooine::ServiceUnavailable,
    504 => Tatooine::GatewayTimeout,
    521 => Tatooine::OriginDown
  }.each do |status, error|
    it "should raise custom error for #{status}" do
      stub_request(:get, "#{Tatooine::API_BASE}films/schema").to_return(
        :body => File.new("./spec/fixtures/film_schema.json")
      )
      stub_request(:get, "#{Tatooine::API_BASE}films/11/").to_return(:status => status)
      expect { Tatooine::Film.get(11) }.to raise_error(error)
    end
  end
end
