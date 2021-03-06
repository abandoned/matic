# Matic

Matic is a dirtier Mongomatic.

Matic adds attribute accessors and dirty tracking to Mongomatic,
defaults the collection name to the plural of the class name, and
optionally shortens field names saved to MongoDB.

![Matic](http://github.com/papercavalier/matic/raw/master/le_fou.jpg)

## Examples

    class Person < Mongomatic::Base
      include Matic

      fields :first_name,
             :last_name
    end

    person = Person.new
    person.first_name = "John"

    person.first_name_changed?
    => true

    person.changes["first_name"]
    => [nil, "John"]

    person.insert

    person.first_name_changed?
    => false

    person.changes["first_name"]
    => nil

    person.previous_changes["first_name"]
    => [nil, "John"]

A model with short field names:

    class Person < Mongomatic::Base
      include Matic

      fields :first_name => 'f',
             :last_name  => 'l'

    end

    person = Person.new

    person.first_name = "John"
    person.last_name = "Doe"

    person.insert
    => #<Person:0x000001023cea30
     @doc=
      {"f"=>"John", "l" => "Doe", "_id"=>BSON::ObjectId('4cdd1b0c6aa2b112e1000001')}
     ...>
