require "./spec/spec_helper"

describe Tatooine::Planet do
  describe "#schema" do
    before(:all) do
      VCR.use_cassette("planet schema") do
        @schema = Tatooine::Planet.schema
      end
    end

    it "should get the description of the class" do
      expect(@schema).to be_instance_of(Hash)
      expect(@schema["description"]).to eq("A planet.")
    end
  end

  describe "#count" do
    before(:all) do
      VCR.use_cassette("planet count") do
        @count = Tatooine::Planet.count
      end
    end

    it "should return the correct count" do
      expect(@count).to be(60)
    end
  end

  describe "#list" do
    before(:all) do
      VCR.use_cassette("planet list") do
        @planets = Tatooine::Planet.list
      end
    end

    it "gets a list of people" do
      expect(@planets).to be_instance_of(Array)
      expect(@planets.length).to be(10)
      expect(@planets.first).to be_instance_of(Tatooine::Planet)
    end

    it "gets the next page" do
      VCR.use_cassette("planet next") do
        @next_planets = Tatooine::Planet.next
        expect(@next_planets).to be_instance_of(Array)
        expect(@next_planets.first).to be_instance_of(Tatooine::Planet)
      end
    end

    it "gets the previous page" do
      VCR.use_cassette("planet previous") do
        @previous_planets = Tatooine::Planet.previous
        expect(@previous_planets.map(&:name)).to match_array(@planets.map(&:name))
      end
    end
  end

  describe "#get" do
    before(:all) do
      VCR.use_cassette("planet 1") do
        @planet = Tatooine::Planet.get(1)
      end
    end

    it "gets the url of the planet" do
      expect(@planet.url).to eq("#{Tatooine::API_BASE}planets/1/")
    end

    it "gets the attributes of the planet" do
      expect(@planet.name).to eq("Tatooine")
    end

    it "gets a list of residents" do
      expect(@planet.residents).to be_instance_of(Array)
      expect(@planet.residents.first).to be_instance_of(Tatooine::Person)
    end

    it "gets a list of films" do
      expect(@planet.films).to be_instance_of(Array)
      expect(@planet.films.first).to be_instance_of(Tatooine::Film)
    end
  end

  describe "#new" do
    it "primes an object with a url" do
      VCR.use_cassette("planet schema") do
        @planet = Tatooine::Planet.new(:url => "#{Tatooine::API_BASE}planets/1/")
        expect(@planet).to respond_to(:name)
      end
    end

    it "gets the object when methods are called" do
      VCR.use_cassette("planet 1 and schema") do
        @planet = Tatooine::Planet.new("url" => "#{Tatooine::API_BASE}planets/1/")
        expect(@planet.name).to eq("Tatooine")
      end
    end

    it "sets properties from an object" do
      VCR.use_cassette("planet schema") do
        @planet = Tatooine::Planet.new("name" => "Anything, because I said so")
        expect(@planet.name).to eq("Anything, because I said so")
      end
    end
  end
end
