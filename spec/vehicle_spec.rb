require "./spec/spec_helper"

describe Tatooine::Vehicle do
  describe "#schema" do
    before(:all) do
      VCR.use_cassette("vehicle schema") do
        @schema = Tatooine::Vehicle.schema
      end
    end

    it "should get the description of the class" do
      expect(@schema).to be_instance_of(Hash)
      expect(@schema["description"]).to eq("A vehicle.")
    end
  end

  describe "#count" do
    before(:all) do
      VCR.use_cassette("vehicle count") do
        @count = Tatooine::Vehicle.count
      end
    end

    it "should return the correct count" do
      expect(@count).to be(39)
    end
  end

  describe "#list" do
    before(:all) do
      VCR.use_cassette("vehicle list") do
        @vehicles = Tatooine::Vehicle.list
      end
    end

    it "gets a list of vehicles" do
      expect(@vehicles).to be_instance_of(Array)
      expect(@vehicles.length).to be(10)
      expect(@vehicles.first).to be_instance_of(Tatooine::Vehicle)
    end

    it "gets the next page" do
      VCR.use_cassette("vehicle next") do
        @next_vehicles = Tatooine::Vehicle.next
        expect(@next_vehicles).to be_instance_of(Array)
        expect(@next_vehicles.first).to be_instance_of(Tatooine::Vehicle)
      end
    end

    it "gets the previous page" do
      VCR.use_cassette("vehicle previous") do
        @previous_vehicles = Tatooine::Vehicle.previous
        expect(@previous_vehicles.map(&:name)).to match_array(@vehicles.map(&:name))
      end
    end
  end

  describe "#get" do
    before(:all) do
      VCR.use_cassette("vehicle 14") do
        @vehicle = Tatooine::Vehicle.get(14)
      end
    end

    it "gets the url of the vehicle" do
      expect(@vehicle.url).to eq("#{Tatooine::API_BASE}vehicles/14/")
    end

    it "gets the attributes of the vehicle" do
      expect(@vehicle.name).to eq("Snowspeeder")
    end

    it "gets a list of pilots" do
      expect(@vehicle.pilots).to be_instance_of(Array)
      expect(@vehicle.pilots.first).to be_instance_of(Tatooine::Person)
    end

    it "gets a list of films" do
      expect(@vehicle.films).to be_instance_of(Array)
      expect(@vehicle.films.first).to be_instance_of(Tatooine::Film)
    end
  end

  describe "#new" do
    it "primes an object with a url" do
      VCR.use_cassette("vehicle schema") do
        @vehicle = Tatooine::Vehicle.new(:url => "#{Tatooine::API_BASE}vehicles/14/")
        expect(@vehicle).to respond_to(:name)
      end
    end

    it "gets the object when methods are called" do
      VCR.use_cassette("vehicle 14 and schema") do
        @vehicle = Tatooine::Vehicle.new("url" => "#{Tatooine::API_BASE}vehicles/14/")
        expect(@vehicle.name).to eq("Snowspeeder")
      end
    end

    it "sets properties from an object" do
      VCR.use_cassette("vehicle schema") do
        @vehicle = Tatooine::Vehicle.new("name" => "Anything, because I said so")
        expect(@vehicle.name).to eq("Anything, because I said so")
      end
    end
  end
end
