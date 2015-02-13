module FeePay
  module API
    class Account
      SERVER_URI = "https://accounts.feepay.switchboard.io"
      
      attr_accessor :auth
      
      def initialize(options = {})
        self.auth = options[:auth]
      end
      
      def get(uuid)
        uuid = URI.escape(uuid.to_s)
        
        request = HTTPI::Request.new
        request.url = "#{SERVER_URI}/api/users/#{uuid}"
        request.headers = self.generate_headers

        response = HTTPI.get(request)
        
        if !response.error?
          JSON.parse(response.body)
        else
          raise(API::Error.new(response.code, response.body))
        end
      end
      
      def create(params)
        request = HTTPI::Request.new
        request.url = "#{SERVER_URI}/api/users/"
        request.body = params
        request.headers = self.generate_headers

        response = HTTPI.post(request)
        
        if !response.error?
          JSON.parse(response.body)
        else
          raise(API::Error.new(response.code, response.body))
        end
      end
      
      def update(uuid, params)
        uuid = URI.escape(uuid.to_s)
        
        request = HTTPI::Request.new
        request.url = "#{SERVER_URI}/api/users/#{uuid}"
        request.body = params
        request.headers = self.generate_headers

        response = HTTPI.put(request)
        
        if !response.error?
          JSON.parse(response.body)
        else
          raise(API::Error.new(response.code, response.body))
        end
      end
      
      def delete(uuid)
        uuid = URI.escape(uuid.to_s)
        
        request = HTTPI::Request.new
        request.url = "#{SERVER_URI}/api/users/#{uuid}"
        request.headers = self.generate_headers
        
        response = HTTPI.delete(request)
        
        if !response.error?
          JSON.parse(response.body)
        else
          raise(API::Error.new(response.code, response.body))
        end
      end
      
      # TODO:: create mapping for relationships api endpoints
      
      private
      
      def generate_headers
        {'User-Agent' => USER_AGENT, 'Client-Secret' => self.auth.client_secret, 'Client-Id' => self.auth.client_id}
      end

    end
  end
end