module Wisebed

  class WebsocketClient < Client

    def initialize(testbed_id, cookie)
      @id = testbed_id
      @cookie = cookie
      @stop = false
    end
    
    def attach(&message_handler)
      EventMachine.run {
        # do not enable any headers... em-http-request will breake! Really!
        header = {#:connection => "Upgrade",
                  # :upgrade => "websocket",
                  :cookie => @cookie,
                   #:origin => Wisebed::BASEURL,
                   #"Sec-WebSocket-Version" => 13,
                   #"Sec-WebSocket-Key" => Base64.urlsafe_encode64(Time.now.to_s) 
                  }
        http = EventMachine::HttpRequest.new(Wisebed::WSBASEURL+"/ws/experiments/"+@id).get :timeout => 0, :head => header

          http.errback { puts "oops" }

          http.callback {
            puts "WebSocket connected!"
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