module Wisebed
  
  class Testbed < Client
    
    attr_reader :cookie, :credentials
  
    def initialize(testbed_id)
      #@web_socket = WisebedClient::WisebedWebsocketClient.new
      @cookie = ""
      @id = testbed_id
    end

    def login!(credentials=nil)
      @credentials = credentials if credentials
      raise "Cannot login: No credentials given!" if not @credentials
      @getback = nil
      url = Wisebed::BASEURL+Wisebed::APIVERSION+@id+"/login"
      puts "debug: requesting "+url
      EventMachine.run {
        http = EventMachine::HttpRequest.new(url).post :body => @credentials.to_json, :head => {"content-type" => "application/json; charset=utf-8"}        
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

    def logout!
      request_from_wisebed @id + "/logout"
      @cookie = ""
      @getback
    end

    def is_logged_in?
      request_from_wisebed @id+"/isLoggedIn"
      not @getback.include? "not logged in"
    end
  
    def personal_reservations(from=nil, to=nil)
      public_reservations(from, to, true)
      @getback
    end

    def public_reservations(from=nil, to=nil, useronly=false)
      login! if @cookie.empty?
      # Time.iso8601 includes the timezone (+01:00), however XMLGreagorianCalendar does not parse this
      request_from_wisebed @id+"/reservations?userOnly="+useronly.to_s+"&"+
        (from ? ("from=" + from.iso8601_no_tz + "&") : "") + (to ? ("to="+to.iso8601_no_tz + "&") : "")
      @getback.nil? ? "not logged in for personal reservations" : @getback["reservations"]
    end

    def wise_ml(experiment_id = nil, json_or_xml = "json")
      # TODO: handle xml
      request_from_wisebed @id+ "/experiments/" + (experiment_id ? experiment_id+"/" : "") + "network"
      @getback
    end

  end 
end