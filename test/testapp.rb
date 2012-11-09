require File.expand_path('../../lib/wisebedclient-ruby.rb', __FILE__)
require 'YAML'


# prints out all testbeds
#puts Wisebed::Client.new.testbeds

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

tb = Wisebed::Testbed.new("uzl")

# gets reservations for Uni Luebeck Testbed
puts tb.is_logged_in?
tb.login!(logindata)
tb.logout!
puts tb.personal_reservations