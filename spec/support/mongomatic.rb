require "mongomatic"

Mongomatic.db = Mongo::Connection.new.db("matic_test")

Rspec.configure do |config|
  config.before do
    Mongomatic.db.collections.each { |c| c.remove }
  end
end
