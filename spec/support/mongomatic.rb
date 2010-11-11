require "mongomatic"

Mongomatic.db = Mongo::Connection.new.db("matic_test")
