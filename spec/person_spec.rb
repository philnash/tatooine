require "./spec/spec_helper"

describe Tatooine::Person do
  describe "#schema" do
    before(:all) do
      VCR.use_cassette("person schema") do
        @schema = Tatooine::Person.schema
      end
    end

    it "should get the description of the class" do
      expect(@schema).to be_instance_of(Hash)
      expect(@schema["description"]).to eq("A person within the Star Wars universe")
    end
  end

  describe "#count" do
    before(:all) do
      VCR.use_cassette("person count") do
        @count = Tatooine::Person.count
      end
    end

    it "should return the correct count" do
      expect(@count).to be(87)
    end
  end

  describe "#list" do
    before(:all) do
      VCR.use_cassette("person list") do
        @people = Tatooine::Person.list
      end
    end

    it "gets a list of people" do
      expect(@people).to be_instance_of(Array)
      expect(@people.length).to be(10)
      expect(@people.first).to be_instance_of(Tatooine::Person)
    end

    it "gets the next page" do
      VCR.use_cassette("person next") do
        @next_people = Tatooine::Person.next
        expect(@next_people).to be_instance_of(Array)
        expect(@next_people.first).to be_instance_of(Tatooine::Person)
      end
    end

    it "gets the previous page" do
      VCR.use_cassette("person previous") do
        @previous_people = Tatooine::Person.previous
        expect(@previous_people.map(&:name)).to match_array(@people.map(&:name))
      end
    end
  end

  describe "#get" do
    before(:all) do
      VCR.use_cassette("person 1") do
        @person = Tatooine::Person.get(1)
      end
    end

    it "gets the url of the person" do
      expect(@person.url).to eq("#{Tatooine::API_BASE}people/1/")
    end

    it "gets the attributes of the person" do
      expect(@person.name).to eq("Luke Skywalker")
    end

    it "gets a planet homeworld" do
      expect(@person.homeworld).to be_instance_of(Tatooine::Planet)
    end

    it "gets a list of films" do
      expect(@person.films).to be_instance_of(Array)
      expect(@person.films.first).to be_instance_of(Tatooine::Film)
    end

    it "gets a list of species" do
      expect(@person.species).to be_instance_of(Array)
      expect(@person.species.first).to be_instance_of(Tatooine::Species)
    end

    it "gets a list of starships" do
      expect(@person.starships).to be_instance_of(Array)
      expect(@person.starships.first).to be_instance_of(Tatooine::Starship)
    end

    it "gets a list of vehicles" do
      expect(@person.vehicles).to be_instance_of(Array)
      expect(@person.vehicles.first).to be_instance_of(Tatooine::Vehicle)
    end
  end

  describe "#new" do
    it "primes an object with a url" do
      VCR.use_cassette("person schema") do
        @person = Tatooine::Person.new(:url => "#{Tatooine::API_BASE}people/1/")
        expect(@person).to respond_to(:name)
      end
    end

    it "gets the object when methods are called" do
      VCR.use_cassette("person 1 and schema") do
        @person = Tatooine::Person.new("url" => "#{Tatooine::API_BASE}people/1/")
        expect(@person.name).to eq("Luke Skywalker")
      end
    end

    it "sets properties from an object" do
      VCR.use_cassette("person schema") do
        @person = Tatooine::Person.new("name" => "Anything, because I said so")
        expect(@person.name).to eq("Anything, because I said so")
      end
    end
  end
end
