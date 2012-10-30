Dir[File.dirname(__FILE__) + '/wisebedclient-ruby/*.rb'].each { |file| require file }
require 'JSON'
require 'eventmachine'
require 'em-http-request'
require 'time' # for easy iso8601 format
class Time
  # WARN: polluting global namespaces here...
  def iso8601_no_tz
    # example: 2012-10-19T13:00:31
    strftime("%Y-%m-%dT%H:%M:%S")
  end
end

module WisebedClient
  WISEBEDBASEURL = "http://wisebed.itm.uni-luebeck.de"
  
end
