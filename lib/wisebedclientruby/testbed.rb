module Wisebed
  
  class Testbed < Client
    
    attr_reader :cookie, :credentials
  
    def initialize(testbed_id)
      #@web_socket = WisebedClient::WisebedWebsocketClient.new
      @cookie = ""
      @id = testbed_id
    end

    def wise_ml(experiment_id = nil, json_or_xml = "json")
      # TODO: handle xml
      request_from_wisebed @id+ "/experiments/" + (experiment_id ? experiment_id+"/" : "") + "network"
      @getback
    end

    def login!(credentials=nil)
      @credentials = credentials if credentials
      raise "Cannot login: No credentials given!" if not @credentials
      post_to_wisebed @id+"/login", @credentials
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
      login! if @cookie.empty?
      public_reservations(from, to, true)
      @getback["reservations"]
    end

    def public_reservations(from=nil, to=nil, useronly=false)
      # Time.iso8601 includes the timezone (+01:00), however XMLGreagorianCalendar does not parse this
      request_from_wisebed @id+"/reservations?userOnly="+useronly.to_s+"&"+
        (from ? ("from=" + from.iso8601_no_tz + "&") : "") + (to ? ("to="+to.iso8601_no_tz + "&") : "")
      @getback.nil? ? "not logged in for personal reservations" : @getback["reservations"]
    end
    
    def make_reservation(from, to, user_data, node_URNs)
      content = {
        "from"     => from.iso8601_no_tz,
        "nodeURNs" => node_URNs,
        "to"       => to.iso8601_no_tz(),
        "userData" => user_data # description or something
      }
      post_to_wisebed @id+"/reservations/create", content
      raise "Another reservation is in conflict with yours" if @getback.include? "Another reservation is in conflict with yours"
      @getback
    end
    
    def delete_reservation
      # TODO implement
    end
    
    def experiments(reservation_data=nil)
      unless reservation_data
        reservation_data = personal_reservations(Time.now, Time.now+(24*60*60)).last["data"]
        reservation_data[0].delete("username")
        reservation_data = {"reservations" => reservation_data}
      end            
      puts "debug reservation_data: #{reservation_data}"
      post_to_wisebed @id+"/experiments", reservation_data
      @getback.split("/").last
    end
    
    def flash(secret_keservation_key, path_to_config)
      flash_this_json = Wisebed::Client.new.experimentconfiguration(path_to_config)
      post_to_wisebed @id+"/experiments/"+secret_keservation_key+"/flash", flash_this_json
      @getback
    end
    
  end
end