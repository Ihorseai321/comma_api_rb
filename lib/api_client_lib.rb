module CommaAPI

  class RPCError < Exception; end
  class RPCError404 < RPCError; end

  module HTTP

    def request(url:)
      uri  = URI url
      req  = Net::HTTP::Get.new uri.request_uri
      req["Authorization"] = "JWT #{::JWT_TOKEN}"
      resp = http(uri: uri).request req
      return RPCError404.new if resp.code == "404"
      JSON.parse resp.body
    end

    def post_request(url:, data:)
      uri  = URI url
      req  = Net::HTTP::Post.new uri.request_uri
      req["Authorization"] = "JWT #{::JWT_TOKEN}"
      req.body = data
      resp = http(uri: uri).request req
      JSON.parse resp.body
    end

    def http(uri:)
      http = Net::HTTP.new uri.host, uri.port
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http
    end

  end


  # TODO: move (and refactor with refinements)

  module Monkeypatches
    class ::Hash
      alias :f :fetch

      def sym_keys
        Hash[self.map{ |key,value| [key.to_sym, value] }]
      end

      def str_keys
        Hash[self.map{ |key,value| [key.to_s, value] }]
      end
    end
  end

end
