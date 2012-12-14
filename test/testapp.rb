require File.expand_path('../../lib/wisebedclientruby.rb', __FILE__)
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
tb.public_reservations
all_nodes_for_packet_tracking = ["urn:wisebed:uzl1:0x211c","urn:wisebed:uzl1:0x2114","urn:wisebed:uzl1:0x2104","urn:wisebed:uzl1:0x2118","urn:wisebed:uzl1:0x2120","urn:wisebed:uzl1:0x2144","urn:wisebed:uzl1:0x2140","urn:wisebed:uzl1:0x2108","urn:wisebed:uzl1:0x2100","urn:wisebed:uzl1:0x210c","urn:wisebed:uzl1:0x2124","urn:wisebed:uzl1:0x2134","urn:wisebed:uzl1:0x2130","urn:wisebed:uzl1:0x212c","urn:wisebed:uzl1:0x2128","urn:wisebed:uzl1:0x2138","urn:wisebed:uzl1:0x213c","urn:wisebed:uzl1:0x2110"]
exp_reservation = tb.make_reservation(Time.now, Time.now+(60), "test reservation from ruby client", all_nodes_for_packet_tracking)
experiment_id = tb.experiments(exp_reservation)
tb.flash(experiment_id,"https://raw.github.com/itm/wisebed-experiments/master/packet-tracking/config.json")
wsc = Wisebed::WebsocketClient.new(experiment_id,tb.cookie)

begin
  attach_time = Time.now
  messages = []
  wsc.attach {|msg| print "."; messages << msg}
  while true do end
rescue Interrupt
ensure
  detach_time = Time.now
  wsc.detach
end

puts "received #{messages.length} messages via websocket in #{detach_time-attach_time}"
