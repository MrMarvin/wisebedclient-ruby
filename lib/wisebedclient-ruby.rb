Dir[File.dirname(__FILE__) + '/wisebedclient-ruby/*.rb'].each { |file| require file }
require 'JSON'
require 'eventmachine'
require 'em-http-request'

module WisebedClient
  WISEBEDBASEURL = "http://wisebed.itm.uni-luebeck.de"
  
end
