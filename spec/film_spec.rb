require "./spec/spec_helper"

describe Tatooine::Film do
  EXPECTED_MOVIE_COUNT = 7

  describe "#schema" do
    before(:all) do
      VCR.use_cassette("film schema") do
        @schema = Tatooine::Film.schema
      end
    end

    it "should get the description of the class" do
      expect(@schema).to be_instance_of(Hash)
      expect(@schema["description"]).to eq("A Star Wars film")
    end
  end

  describe "#count" do
    before(:all) do
      VCR.use_cassette("film count") do
        @count = Tatooine::Film.count
      end
    end

    it "should return the correct count" do
      expect(@count).to be(EXPECTED_MOVIE_COUNT)
    end
  end

  describe "#list" do
    before(:all) do
      VCR.use_cassette("film list") do
        @films = Tatooine::Film.list
      end
    end

    it "gets a list of films" do
      expect(@films).to be_instance_of(Array)
      expect(@films.length).to be(EXPECTED_MOVIE_COUNT)
      expect(@films.first).to be_instance_of(Tatooine::Film)
    end
  end

  describe "#get" do
    before(:all) do
      VCR.use_cassette("film 1") do
        @film = Tatooine::Film.get(1)
      end
    end

    it "gets the url of the film" do
      expect(@film.url).to eq("#{Tatooine::API_BASE}films/1/")
    end

    it "gets the attributes of the film" do
      expect(@film.title).to eq("A New Hope")
      expect(@film.episode_id).to eq(4)
    end

    it "gets a list of characters" do
      expect(@film.characters).to be_instance_of(Array)
      expect(@film.characters.first).to be_instance_of(Tatooine::Person)
    end

    it "gets a list of planets" do
      expect(@film.planets).to be_instance_of(Array)
      expect(@film.planets.first).to be_instance_of(Tatooine::Planet)
    end

    it "gets a list of species" do
      expect(@film.species).to be_instance_of(Array)
      expect(@film.species.first).to be_instance_of(Tatooine::Species)
    end

    it "gets a list of starships" do
      expect(@film.starships).to be_instance_of(Array)
      expect(@film.starships.first).to be_instance_of(Tatooine::Starship)
    end

    it "gets a list of vehicles" do
      expect(@film.vehicles).to be_instance_of(Array)
      expect(@film.vehicles.first).to be_instance_of(Tatooine::Vehicle)
    end
  end

  describe "#new" do
    it "primes an object with a url" do
      VCR.use_cassette("film schema") do
        @film = Tatooine::Film.new("url" => "#{Tatooine::API_BASE}films/1/")
        expect(@film).to respond_to(:title)
      end
    end

    it "gets the object when methods are called" do
      VCR.use_cassette("film 1 and schema") do
        @film = Tatooine::Film.new("url" => "#{Tatooine::API_BASE}films/1/")
        expect(@film.title).to eq("A New Hope")
      end
    end

    it "sets properties from an object" do
      VCR.use_cassette("film schema") do
        @film = Tatooine::Film.new("title" => "Anything, because I said so")
        expect(@film.title).to eq("Anything, because I said so")
      end
    end
  end
end
