module FeePay
  module API
    class Config
      def self.server_uri
        if FeePay::API.testmode
          "https://config.pre.feepay.switchboard.io"
        else
          "https://config.feepay.switchboard.io"
        end
      end
          
      def districts
        request = HTTPI::Request.new
        request.url = "#{self.class.server_uri}/districts"
        request.headers = {'User-Agent' => USER_AGENT}

        response = HTTPI.get(request)
        
        if !response.error?
          JSON.parse(response.body)
        else
          raise(API::Error.new(response.code, response.body))
        end
      end
      
      def get(subdomain_or_sn)
        subdomain_or_sn = URI.escape(subdomain_or_sn.to_s)
        
        request = HTTPI::Request.new
        request.url = "#{self.class.server_uri}/districts/#{subdomain_or_sn}"
        request.headers = {'User-Agent' => USER_AGENT}

        response = HTTPI.get(request)
        
        if !response.error?
          JSON.parse(response.body)
        else
          raise(API::Error.new(response.code, response.body))
        end
      end
      
      def get_by(key, value)
        key = URI.escape(key.to_s)
        value = URI.escape(value.to_s)
        
        request = HTTPI::Request.new
        request.url = "#{self.class.server_uri}/districts/by/#{key}/#{value}"
        request.headers = {'User-Agent' => USER_AGENT}

        response = HTTPI.get(request)
        
        if !response.error?
          JSON.parse(response.body)
        else
          raise(API::Error.new(response.code, response.body))
        end        
      end
    
    end
  end
end