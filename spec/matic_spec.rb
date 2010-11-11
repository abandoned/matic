require "spec_helper"

describe "A matic model" do

  let(:person) { Person.new }

  it "has a collection first_name" do
    person.class.collection_name.should eql "people"
  end

  describe ".field" do
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

  context "dirty tracking" do

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

    shared_examples_for "a dirty object" do

      it "tells if an attribute changed" do
        person.first_name_changed?.should be_true
        person.last_name_changed?.should be_true
      end

      it "remembers changes to an attribute" do
        person.changes["first_name"].should eql [nil, "John"]
        person.changes["last_name"].should eql [nil, "Doe"]
      end

    end

    context "when object is new" do

      before do
        person.first_name = "John"
        person.last_name = "Doe"
      end

      it_behaves_like "a dirty object"

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

      it_behaves_like "a dirty object"

      describe "#update" do

        before { person.update }

        it_behaves_like "a dirty-tracking command"

      end

      describe "#update!" do

        before { person.update! }

        it_behaves_like "a dirty-tracking command"

      end

    end

    context "when object is not valid" do

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

end
