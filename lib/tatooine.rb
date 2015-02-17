require "faraday"
require "faraday_middleware"

require "tatooine/version"
require "tatooine/error"
require "tatooine/middleware/raise_http_error"
require "tatooine/resource"
require "tatooine/film"
require "tatooine/person"
require "tatooine/planet"
require "tatooine/species"
require "tatooine/starship"
require "tatooine/vehicle"

module Tatooine
  API_BASE = "http://swapi.co/api/"
end
