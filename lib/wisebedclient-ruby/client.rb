module Wisebed

  BASEURL = "http://wisebed.itm.uni-luebeck.de"
  WSBASEURL = "ws://wisebed.itm.uni-luebeck.de"
  APIVERSION = "/rest/2.3/"

  class Client

    def testbeds
      request_from_wisebed "testbeds"
      @getback["testbedMap"]
    end
    
    def experimentconfiguration= (url)
      request_from_wisebed "experimentconfiguration?url=#{url}"
    end

    def request_from_wisebed(url_extension)
      @getback = nil
      url = Wisebed::BASEURL+Wisebed::APIVERSION+url_extension
      puts "debug: requesting "+url
      EventMachine.run {
        http = EventMachine::HttpRequest.new(url).get :head => {:accept => "application/json", :cookie => @cookie}
        http.errback { p 'Uh oh'; EM.stop }
        http.callback {
          @getback = http.response
          begin
            @getback = JSON.parse http.response
          rescue JSON::ParserError => e
            puts STDERR, "Could not parse response: No valid JSON.\nException message given: " + e.message
            puts STDERR, http.response.empty? ? http.response_header : http.response
            @getback = http.response
          end 
          EventMachine.stop
          }
        }
    end
    
    def post_to_wisebed(url_extension, data)
      @getback = nil
      url = Wisebed::BASEURL+Wisebed::APIVERSION+url_extension
      puts "debug: requesting "+url
      EventMachine.run {
        http = EventMachine::HttpRequest.new(url).post :body => data.to_json, :head => {"content-type" => "application/json; charset=utf-8", :cookie => @cookie}
        http.errback { p 'Uh oh'; EM.stop }
        http.callback {
          @cookie = http.response_header["SET_COOKIE"] if http.response_header["SET_COOKIE"]
          begin
            @getback = JSON.parse http.response
          rescue JSON::ParserError => e
            puts STDERR, "Could not parse response: No valid JSON.\nException message given: " + e.message
            puts STDERR, http.response.empty? ? http.response_header : http.response
            @getback = http.response
          end 
          EventMachine.stop
        }
      }      
    end
    
  end
end