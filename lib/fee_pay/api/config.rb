module FeePay
  module API
    class Config
      SERVER_URI = "https://config.feepay.switchboard.io"
    
      def districts
        request = HTTPI::Request.new
        request.url = "#{SERVER_URI}/districts"
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
        request.url = "#{SERVER_URI}/districts/#{subdomain_or_sn}"
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
        request.url = "#{SERVER_URI}/districts/by/#{key}/#{value}"
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