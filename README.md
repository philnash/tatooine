# Tatooine

A Ruby interface to [SWAPI](http://swapi.co/) (the Star Wars API).

## Installation

Add this line to your application's Gemfile:

    gem 'tatooine'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tatooine

## Usage

There are 6 resources available: Planets, Starships, Vehicles, People, Films and Species. They all have a similar interface.

```ruby
planets = Tatooine::Planet.list
Tatooine::Planet.count
# => 60
planets.length
# => 10 # resources are paginated
planets.concat Tatooine::Planet.next
planets.length
# => 20

tatooine = Tatooine::Planet.get(1)
tatooine.name
# => "Tatooine"
tatooine.residents
# => [<Tatooine::Person>, ...]
tatooine.residents.first.name
# => "Luke Skywalker" # Will make the request to get the resource
```

## Schema

In SWAPI the objects are described by their [schemas](http://swapi.co/documentation#schema). Check the [SWAPI documentation](http://swapi.co/documentation) to find out more about each of the objects.

## Contributing

1. Fork it ( https://github.com/philnash/tatooine/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
