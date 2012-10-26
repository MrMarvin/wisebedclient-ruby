require File.expand_path('../../lib/wisebedclient-ruby.rb', __FILE__)

client = WisebedClient::Wisebed.new

# tests the iso8601 time
puts Time.now.iso8601_no_tz

# prints out all testbeds
#puts client.testbeds

# gets reservations for Uni Luebeck Testbed
id = "uzl"
puts client.public_reservations(id,(Time.now-604800),(Time.now+604800))