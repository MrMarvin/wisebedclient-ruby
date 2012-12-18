module Wisebed
  
  class Testbed < Client
    
    attr_reader :cookie, :credentials
  
    def initialize(testbed_id)
      @cookie = ""
      @id = testbed_id
    end

    def wise_ml(experiment_id = nil, json_or_xml = "json")
      # TODO: handle xml
      request_from_wisebed(@id+ "/experiments/" + (experiment_id ? experiment_id+"/" : "") + "network")
    end

    def login!(credentials=nil)
      @credentials = credentials if credentials
      raise "Cannot login: No credentials given!" if not @credentials
      res = post_to_wisebed @id+"/login", @credentials
      @secret_authentication_keys = res
    end

    def logout!
      request_from_wisebed @id + "/logout"
      @cookie = ""
    end

    def is_logged_in?
      res = request_from_wisebed @id+"/isLoggedIn"
      not res.include? "not logged in"
    end
  
    def personal_reservations(from=nil, to=nil)
      login! if @cookie.empty?
      public_reservations(from, to, true)["reservations"]
    end

    def public_reservations(from=nil, to=nil, useronly=false)
      # Time.iso8601 includes the timezone (+01:00), however XMLGreagorianCalendar does not parse this
      res = request_from_wisebed @id+"/reservations?userOnly="+useronly.to_s+"&"+
        (from ? ("from=" + from.iso8601_no_tz + "&") : "") + (to ? ("to="+to.iso8601_no_tz + "&") : "")
      res.nil? ? "not logged in for personal reservations" : res["reservations"]
    end
    
    def make_reservation(from, to, user_data, node_URNs)
      content = {
        "from"     => from.iso8601_no_tz,
        "nodeURNs" => node_URNs,
        "to"       => to.iso8601_no_tz(),
        "userData" => user_data # description or something
      }
      res = post_to_wisebed(@id+"/reservations/create", content)
      raise "Another reservation is in conflict with yours" if res.include? "Another reservation is in conflict with yours"
      res
    end
    
    def delete_reservation(reservation_hash)
      delete_from_wisebed(@id+"/reservations", reservation_hash)
    end
    
    def experiments(reservation_data=nil)
      unless reservation_data
        reservation_data = personal_reservations(Time.now, Time.now+(24*60*60)).last["data"]
        reservation_data[0].delete("username")
        reservation_data = {"reservations" => reservation_data}
      end            
      res = post_to_wisebed(@id+"/experiments", reservation_data)
      res.split("/").last
    end
    
    def flash(secret_keservation_key, path_to_config)
      flash_this_json = Wisebed::Client.new.experimentconfiguration(path_to_config)
      post_to_wisebed(@id+"/experiments/"+secret_keservation_key+"/flash", flash_this_json)
    end
    
  end
end