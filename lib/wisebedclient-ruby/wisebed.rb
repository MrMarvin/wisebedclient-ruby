module WisebedClient

  class Wisebed

    def intialize
      @web_socket = WisebedClient::WisebedWebsocketClient.new  
    end

    def testCookie
      
    end

    def personal_reservations(testbedId, from=nil, to=nil)
      public_reservations(testbedId, from , to, true)
      @getback
    end
    
    def public_reservations(testbedId, from=nil, to=nil, useronly=false) 
      # Time.iso8601 includes the timezone (+01:00), however XMLGreagorianCalendar does not parse this
      request_from_wisebed "/rest/2.3/"+testbedId+"/reservations?userOnly="+useronly.to_s+"&"+
        (from ? ("from=" + from.iso8601_no_tz + "&") : "") + (to ? ("to="+to.iso8601_no_tz + "&") : "")
      @getback["reservations"]
    end

    def testbeds
      request_from_wisebed "/rest/2.3/testbeds"
      @getback["testbedMap"]
    end

    def request_from_wisebed(url_extension)
      @getback = nil
      url = WisebedClient::WISEBEDBASEURL+url_extension
      EventMachine.run {
        http = EventMachine::HttpRequest.new(url).get  :dataType => "json"
        http.errback { p 'Uh oh'; EM.stop }
        http.callback {
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