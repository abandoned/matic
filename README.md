# Matic

Matic adds attribute accessors and dirty tracking to Mongomatic.

## Examples

    class Person < Mongomatic::Base
      include Matic

      field :name
    end

    person = Person.new
    person.name = "John Doe"

    person.name_changed?
    => true

    person.changes["name"]
    => [nil, "John Doe"]

    person.insert

    person.name_changed?
    => false

    person.changes["name"]
    => nil

    person.previous_changes["name"]
    => [nil, "John Doe"]
