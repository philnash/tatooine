require "./spec/spec_helper"

describe Tatooine::Species do
  describe "#schema" do
    before(:all) do
      VCR.use_cassette("species schema") do
        @schema = Tatooine::Species.schema
      end
    end

    it "should get the description of the class" do
      expect(@schema).to be_instance_of(Hash)
      expect(@schema["description"]).to eq("A species within the Star Wars universe")
    end
  end

  describe "#count" do
    before(:all) do
      VCR.use_cassette("species count") do
        @count = Tatooine::Species.count
      end
    end

    it "should return the correct count" do
      expect(@count).to be(37)
    end
  end

  describe "#list" do
    before(:all) do
      VCR.use_cassette("species list") do
        @species = Tatooine::Species.list
      end
    end

    it "gets a list of species" do
      expect(@species).to be_instance_of(Array)
      expect(@species.length).to be(10)
      expect(@species.first).to be_instance_of(Tatooine::Species)
    end

    it "gets the next page" do
      VCR.use_cassette("species next") do
        @next_species = Tatooine::Species.next
        expect(@next_species).to be_instance_of(Array)
        expect(@next_species.first).to be_instance_of(Tatooine::Species)
      end
    end

    it "gets the previous page" do
      VCR.use_cassette("species previous") do
        @previous_species = Tatooine::Species.previous
        expect(@previous_species.map(&:name)).to match_array(@species.map(&:name))
      end
    end
  end

  describe "#get" do
    before(:all) do
      VCR.use_cassette("species 1") do
        @species = Tatooine::Species.get(1)
      end
    end

    it "gets the url of the species" do
      expect(@species.url).to eq("#{Tatooine::API_BASE}species/1/")
    end

    it "gets the attributes of the species" do
      expect(@species.name).to eq("Human")
    end

    it "gets a planet homeworld" do
      expect(@species.homeworld).to be_instance_of(Tatooine::Planet)
    end

    it "gets a list of films" do
      expect(@species.films).to be_instance_of(Array)
      expect(@species.films.first).to be_instance_of(Tatooine::Film)
    end

    # Skipped because the schema doesn't return people right now.
    it "gets a list of people" do
      expect(@species.people).to be_instance_of(Array)
      expect(@species.people.first).to be_instance_of(Tatooine::Person)
    end
  end

  describe "#new" do
    it "primes an object with a url" do
      VCR.use_cassette("species schema") do
        @species = Tatooine::Species.new(:url => "#{Tatooine::API_BASE}species/1/")
        expect(@species).to respond_to(:name)
      end
    end

    it "gets the object when methods are called" do
      VCR.use_cassette("species 1 and schema") do
        @species = Tatooine::Species.new("url" => "#{Tatooine::API_BASE}species/1/")
        expect(@species.name).to eq("Human")
      end
    end

    it "sets properties from an object" do
      VCR.use_cassette("species schema") do
        @species = Tatooine::Species.new("name" => "Anything, because I said so")
        expect(@species.name).to eq("Anything, because I said so")
      end
    end
  end
end
