require "./spec/spec_helper"

describe Tatooine::Starship do
  describe "#schema" do
    before(:all) do
      VCR.use_cassette("starship schema") do
        @schema = Tatooine::Starship.schema
      end
    end

    it "should get the description of the class" do
      expect(@schema).to be_instance_of(Hash)
      expect(@schema["description"]).to eq("A Starship")
    end
  end

  describe "#count" do
    before(:all) do
      VCR.use_cassette("starship count") do
        @count = Tatooine::Starship.count
      end
    end

    it "should return the correct count" do
      expect(@count).to be(37)
    end
  end

  describe "#list" do
    before(:all) do
      VCR.use_cassette("starship list") do
        @starships = Tatooine::Starship.list
      end
    end

    it "gets a list of people" do
      expect(@starships).to be_instance_of(Array)
      expect(@starships.length).to be(10)
      expect(@starships.first).to be_instance_of(Tatooine::Starship)
    end

    it "gets the next page" do
      VCR.use_cassette("starship next") do
        @next_starships = Tatooine::Starship.next
        expect(@next_starships).to be_instance_of(Array)
        expect(@next_starships.first).to be_instance_of(Tatooine::Starship)
      end
    end

    it "gets the previous page" do
      VCR.use_cassette("starship previous") do
        @previous_starships = Tatooine::Starship.previous
        expect(@previous_starships.map(&:name)).to match_array(@starships.map(&:name))
      end
    end
  end

  describe "#get" do
    before(:all) do
      VCR.use_cassette("starship 10") do
        @starship = Tatooine::Starship.get(10)
      end
    end

    it "gets the url of the starship" do
      expect(@starship.url).to eq("#{Tatooine::API_BASE}starships/10/")
    end

    it "gets the attributes of the starship" do
      expect(@starship.name).to eq("Millennium Falcon")
    end

    it "gets a list of residents" do
      expect(@starship.pilots).to be_instance_of(Array)
      expect(@starship.pilots.first).to be_instance_of(Tatooine::Person)
    end

    it "gets a list of films" do
      expect(@starship.films).to be_instance_of(Array)
      expect(@starship.films.first).to be_instance_of(Tatooine::Film)
    end
  end

  describe "#new" do
    it "primes an object with a url" do
      VCR.use_cassette("starship schema") do
        @starship = Tatooine::Starship.new(:url => "#{Tatooine::API_BASE}starships/10/")
        expect(@starship).to respond_to(:name)
      end
    end

    it "gets the object when methods are called" do
      VCR.use_cassette("starship 2 and schema") do
        @starship = Tatooine::Starship.new("url" => "#{Tatooine::API_BASE}starships/10/")
        expect(@starship.name).to eq("Millennium Falcon")
      end
    end

    it "sets properties from an object" do
      VCR.use_cassette("starship schema") do
        @starship = Tatooine::Starship.new("name" => "Anything, because I said so")
        expect(@starship.name).to eq("Anything, because I said so")
      end
    end
  end
end
