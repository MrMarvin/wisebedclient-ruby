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
#puts tb.wise_ml

# gets reservations for Uni Luebeck Testbed
tb.login!(logindata)
# puts "logged in: "+tb.is_logged_in?.to_s
puts tb.personal_reservations
puts tb.make_reservation(Time.now, Time.now+(5*60), "test reservation from ruby client", ["urn:wisebed:uzl1:0x2144","urn:wisebed:uzl1:0x2246"])
puts tb.personal_reservations

puts Wisebed::Client.new.experimentconfiguration="https://raw.github.com/itm/wisebed-experiments/master/packet-tracking/config.json"