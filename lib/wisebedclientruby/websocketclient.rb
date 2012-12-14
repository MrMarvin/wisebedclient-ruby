module Wisebed

  class WebsocketClient < Client
    require 'em-websocket-client'

    def initialize(exp_id, cookie)
      @exp_id = exp_id
      @cookie = cookie
      @stop = false
    end
    
    def attach(&message_handler)
      EventMachine.run {

        #puts "debug: connecting to: #{Wisebed::WSBASEURL+"/ws/experiments/"+@exp_id}"
        http = EventMachine::WebSocketClient.connect(Wisebed::WSBASEURL+"/ws/experiments/"+@exp_id)

          http.errback { puts "WEBSOCKET CONNECTION ERROR" }

          http.callback {
            #puts "debug: WebSocket connected!"
          }
          
          http.stream { |msg|
            message_handler.call(JSON.parse(msg))
            EventMachine.stop if @stop
          }
      }
    end
    
    def detach
      @stop = true
      puts "WebSocket detaching..."
    end
    
  end
   
end