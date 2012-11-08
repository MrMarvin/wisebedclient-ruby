module WisebedClient

  class Wisebed

    def intialize
      @web_socket = WisebedClient::WisebedWebsocketClient.new
      @cookie = ""
      @secret_authentication_keys = {"secretAuthenticationKeys"=>[]}
    end
    
    def cookie
      @cookie.to_s
    end

    def testCookie
      
    end

    def login!(testbed_id,credentials)
      @getback = nil
      url = WisebedClient::WISEBEDBASEURL+WISEBEDAPIVERSION+testbed_id+"/login"
      puts "debug: requesting "+url
      EventMachine.run {
        http = EventMachine::HttpRequest.new(url).post :body => credentials.to_json, :head => {"content-type" => "application/json; charset=utf-8"}        
        http.errback { p 'Uh oh'; EM.stop }
        http.callback {
          @cookie = http.response_header["SET_COOKIE"] 
          begin
            @getback = JSON.parse http.response            
          rescue JSON::ParserError => e
          end 
          EventMachine.stop
        }
      }
      @secret_authentication_keys = @getback      
    end
    
    def logout!(testbed_id)
      request_from_wisebed WISEBEDAPIVERSION + testbed_id + "/logout"
      @cookie = ""
      @getback
    end
    
    def is_logged_in? (testbed_id)
      request_from_wisebed WISEBEDAPIVERSION+testbed_id+"/isLoggedIn"
      not @getback.include? "not logged in"
    end

    def personal_reservations(testbed_id, from=nil, to=nil)
      public_reservations(testbed_id, from , to, true)
      @getback
    end
    
    def public_reservations(testbed_id, from=nil, to=nil, useronly=false) 
      # Time.iso8601 includes the timezone (+01:00), however XMLGreagorianCalendar does not parse this
      request_from_wisebed WISEBEDAPIVERSION+testbed_id+"/reservations?userOnly="+useronly.to_s+"&"+
        (from ? ("from=" + from.iso8601_no_tz + "&") : "") + (to ? ("to="+to.iso8601_no_tz + "&") : "")
      @getback.nil? ? "not logged in for personal reservations" : @getback["reservations"]
    end

    def testbeds
      request_from_wisebed "/rest/2.3/testbeds"
      @getback["testbedMap"]
    end

    def request_from_wisebed(url_extension)
      @getback = nil
      url = WisebedClient::WISEBEDBASEURL+url_extension
      puts "debug: requesting "+url
      EventMachine.run {
        http = EventMachine::HttpRequest.new(url).get  :dataType => "json", :head => {:cookie => @cookie}
        http.errback { p 'Uh oh'; EM.stop }
        http.callback {
          @getback = http.response
          begin
            @getback = JSON.parse http.response
          rescue JSON::ParserError => e
            #puts STDERR, "Could not parse response: No valid JSON.\nException message given: " + e.message
            #puts STDERR, http.response.empty? ? http.response_header : http.response
          end 
          EventMachine.stop
          }
        }
    end

  end
   
end