require File.expand_path('../../lib/wisebedclient-ruby.rb', __FILE__)
require 'YAML'

client = WisebedClient::Wisebed.new

# tests the iso8601 time
#puts Time.now.iso8601_no_tz

# prints out all testbeds
#puts client.testbeds

# gets reservations for Uni Luebeck Testbed
id = "uzl"
#puts client.public_reservations(id,Time.now,(Time.now+604800))

# example:
# logindata = {
#  "authenticationData" => [
#    {
#      "urnPrefix" => "urn:wisebed:uzl1:",
#      "username" => "user.name@host.example",
#      "password"=> "p4zzw0rd"
#    }
#  ]
# }  
logindata = YAML.load_file(File.expand_path('../credentials.yml', __FILE__))
#puts client.is_logged_in? id
client.login!(id,logindata)
#puts client.is_logged_in? id

# after logging in, we can see our reservations
#puts client.personal_reservations(id,Time.now,(Time.now+604800))

#puts client.logout!(id)
# after logging out again, we cant see it...
#puts client.personal_reservations(id,Time.now,(Time.now+604800))

puts client.wise_ml(id)