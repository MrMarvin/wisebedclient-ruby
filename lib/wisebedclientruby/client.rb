module Wisebed

  BASEURL = "http://wisebed.itm.uni-luebeck.de"
  WSBASEURL = "ws://wisebed.itm.uni-luebeck.de"
  APIVERSION = "/rest/2.3"

  class Client
    require 'httparty'
    include HTTParty
    base_uri Wisebed::BASEURL+Wisebed::APIVERSION

    def testbeds
      request_from_wisebed("testbeds")["testbedMap"]
    end
    
    def experimentconfiguration(url)
      request_from_wisebed("experimentconfiguration?url=#{url}")
    end

    def request_from_wisebed(url_extension)
      url_extension = "/#{url_extension}" unless url_extension[0] == "/"
      #puts "debug: requesting "+self.class.base_uri+url_extension
      if @cookie
        headers = {'Cookie' => @cookie}
      else
        headers = {}
      end      
      res = self.class.get(url_extension, :headers => headers)
      begin        
        JSON.parse(res.body)
      rescue JSON::ParserError => e
        res.body
      end
    
    end

    
    def post_to_wisebed(url_extension, data)
      url_extension = "/#{url_extension}" unless url_extension[0] == "/"
      #puts "debug: posting "+self.class.base_uri+url_extension
      #puts "debug: with data: #{data.to_json}"
      if @cookie
        headers = {'Cookie' => @cookie}
      else
        headers = {}
      end
      headers.merge!({'Content-Type' => "application/json; charset=utf-8"})
      res = self.class.post(url_extension, :body => data.to_json, :headers => headers)
      @cookie = res.headers['Set-Cookie'] if res.headers['Set-Cookie']
      begin        
        JSON.parse(res.body)
      rescue JSON::ParserError => e
        res.body
      end
    end
    
    def delete_from_wisebed(url_extension, data)
      url_extension = "/#{url_extension}" unless url_extension[0] == "/"
      #puts "debug: deleting "+self.class.base_uri+url_extension
      if @cookie
        headers = {'Cookie' => @cookie}
      else
        headers = {}
      end
      headers.merge!({'Content-Type' => "application/json; charset=utf-8"})
      res = self.class.delete(url_extension, :body => data.to_json, :headers => headers)
      begin        
        JSON.parse(res.body)
      rescue JSON::ParserError => e
        res.body
      end
    end
    
  end
end