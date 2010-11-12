require 'benchmark'
require File.expand_path("../../spec/spec_helper", __FILE__)

print "How many books would you like me to create, sir? "
many = STDIN.gets.to_i

Benchmark.bmbm do |x|

  Book.collection.remove

  x.report("mongomatic") do
    many.times do
      book = Book.new
      book["t"] = Faker::Company.catch_phrase
      book["a"] = Faker::Name.name
      book["p"] = Faker::Company.name
      book.insert
    end
  end

  Book.collection.remove

  x.report("matic") do
    many.times do
      book = Book.new
      book.title     = Faker::Company.catch_phrase
      book.authors   = Faker::Name.name
      book.publisher = Faker::Company.name
      book.insert
    end
  end
end
