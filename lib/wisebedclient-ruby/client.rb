module Wisebed

  BASEURL = "http://wisebed.itm.uni-luebeck.de"
  APIVERSION = "/rest/2.3/"

  class Client

    def testbeds
      request_from_wisebed "testbeds"
      @getback["testbedMap"]
    end

    def request_from_wisebed(url_extension)
      @getback = nil
      url = Wisebed::BASEURL+Wisebed::APIVERSION+url_extension
      puts "debug: requesting "+url
      EventMachine.run {
        http = EventMachine::HttpRequest.new(url).get  :dataType => "json", :head => {:cookie => @cookie}
        http.errback { p 'Uh oh'; EM.stop }
        http.callback {
          @getback = http.response
          begin
            @getback = JSON.parse http.response
          rescue JSON::ParserError => e
            puts STDERR, "Could not parse response: No valid JSON.\nException message given: " + e.message
            puts STDERR, http.response.empty? ? http.response_header : http.response
          end 
          EventMachine.stop
          }
        }
    end   
  end
end