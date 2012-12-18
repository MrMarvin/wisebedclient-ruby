module Wisebed

  class WebsocketClient < Client
    require 'simpleblockingwebsocketclient'

    def initialize(secret_exp_id)
      @secret_exp_id = secret_exp_id
    end
    
    def attach(&message_handler)      
      @ws = WebSocket.new(Wisebed::WSBASEURL+"/ws/experiments/"+@secret_exp_id) { |msg| message_handler.call(msg) }
    end
    
    def detach
      puts "WebSocket detaching..."
      @ws.close
    end
    
  end
   
end