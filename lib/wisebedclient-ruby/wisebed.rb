module WisebedClient

  class Wisebed

    def intialize
      @web_socket = WisebedClient::WisebedWebsocketClient.new  
    end

    def testCookie
      
    end

    def personal_reservations(testbedId, from=nil, to=nil)
      public_reservations(testbedId, from , to, true)
    end
    
    def public_reservations(testbedId, from=nil, to=nil, useronly=false) 
          request_from_wisebed "/rest/2.3/"+testbedId+"/reservations?userOnly="+useronly.to_s+
            (from ? ("from=" + from.to_s + "&") : "") + (to ? ("to="+to.toISOString() + "&") : "")
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
          @getback = JSON.parse http.response
          EventMachine.stop
          }
        }
    end

  end
   
end