module FeePay
  module API
    class Account
      def self.server_uri
        if FeePay::API.testmode
          "https://accounts.pre.feepay.switchboard.io"
        else
          "https://accounts.feepay.switchboard.io"
        end
      end

      attr_accessor :auth
      
      def initialize(options = {})
        self.auth = options[:auth]
        
        raise API::InitializerError.new(:auth, "can't be blank") if self.auth.nil?
        raise API::InitializerError.new(:auth, "must be of class type FeePay::API::Auth") if !self.auth.is_a?(FeePay::API::Auth)
      end
      
      def get(uuid)
        uuid = URI.escape(uuid.to_s)
        
        request = HTTPI::Request.new
        request.url = "#{self.class.server_uri}/api/users/#{uuid}"
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
        request.url = "#{self.class.server_uri}/api/users/"
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
        request.url = "#{self.class.server_uri}/api/users/#{uuid}"
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
        request.url = "#{self.class.server_uri}/api/users/#{uuid}"
        request.headers = self.generate_headers
        
        response = HTTPI.delete(request)
        
        if !response.error?
          JSON.parse(response.body)
        else
          raise(API::Error.new(response.code, response.body))
        end
      end
      
      # TODO:: create mapping for relationships api endpoints
      
      protected
      
      def generate_headers
        {'User-Agent' => USER_AGENT, 'Client-Secret' => self.auth.client_secret, 'Client-Id' => self.auth.client_id}
      end

    end
  end
end