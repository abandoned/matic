require "spec_helper"

describe "a mongomatic model that includes matic" do

  let(:person) { Person.new }
  let(:book) { Book.new }

  it "has a collection first_name" do
    person.class.collection_name.should eql "people"
  end

  describe ".fields" do

    context "when it is passed an array" do

      it "defines a getter" do
        person["first_name"] = "John"

        person.first_name.should eql "John"
        lambda { person.foo }.should raise_error NoMethodError
      end

      it "defines a setter" do
        person.first_name = "John"

        person["first_name"].should eql "John"
        lambda { person.foo= "bar" }.should raise_error NoMethodError
      end

    end

    context "when it is passed a hash" do

      it "defines a getter" do
        book["i"] = "9780485113358"
        book.isbn.should eql "9780485113358"

        book["a"] = ["Gilles Deleuze"]
        book.authors.should eql ["Gilles Deleuze"]
      end

      it "defines a setter" do
        book.isbn = "9780485113358"
        book["i"].should eql "9780485113358"

        book.authors = ["Gilles Deleuze"]
        book["a"].should eql ["Gilles Deleuze"]
      end

      it "stores documents with short field names" do
        book.isbn = "9780485113358"
        book.insert

        book.instance_variable_get(:@doc).should have_key 'i'
      end
    end

  end

  shared_examples_for "a dirty-tracking command" do

    it "marks a current change as previous" do
      person.first_name_changed?.should be_false
      person.previous_changes["first_name"].should eql [nil, "John"]

      person.last_name_changed?.should be_false
      person.previous_changes["last_name"].should eql [nil, "Doe"]
    end

    it "does callbacks" do
      person.instance_variable_get(:@called_back).should be_true
    end

  end

  describe "a dirty-tracking setter" do

    context "when an attribute is set" do

      context "and its value has changed" do

        before do
          person.first_name = "John"
        end

        it "marks the attribute as changed" do
          person.first_name_changed?.should be_true
        end

        it "remembers changes to the attribute" do
          person.changes["first_name"].should eql [nil, "John"]
        end

      end

      context "and its value has not changed" do

        before do
          person.first_name = nil
        end

        it "does not mark the attribute as changed" do
          person.first_name_changed?.should be_false
        end

      end

    end

  end

  context "when object is new" do

    before do
      person.first_name = "John"
      person.last_name = "Doe"
    end

    describe "#insert" do

      before { person.insert }

      it_behaves_like "a dirty-tracking command"

    end

    describe "#insert!" do

      before { person.insert! }

      it_behaves_like "a dirty-tracking command"

    end

    describe "#save" do

      before { person.save }

      it_behaves_like "a dirty-tracking command"

    end

  end

  context "when object is not new" do

    before do
      person.insert
      person.instance_variable_set(:@called_back, false)
      person.first_name = "John"
      person.last_name = "Doe"
    end

    describe "#update" do

      before { person.update }

      it_behaves_like "a dirty-tracking command"

    end

    describe "#update!" do

      before { person.update! }

      it_behaves_like "a dirty-tracking command"

    end

  end

  context "when an invalid object is saved" do

    before do
      person.stub!(:valid?).and_return(false)
      person.first_name = "John"
    end

    it "does not clear changes" do
      person.save
      person.first_name_changed?.should be_true
    end

  end

end
