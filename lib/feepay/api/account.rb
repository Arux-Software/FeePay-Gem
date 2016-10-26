module FeePay
  module API
    class Account
      def self.server_uri
        if FeePay::API.standardmode?
          "https://accounts.feepay.switchboard.io"
        elsif FeePay::API.testmode?
          "https://accounts.pre.feepay.switchboard.io"
        elsif FeePay::API.devmode?
          "http://accounts.localfeepay.switchboard.io:5678"
        end
      end

      attr_accessor :auth
      
      def initialize(options = {})
        self.auth = options[:auth]
        
        raise API::InitializerError.new(:auth, "can't be blank") if self.auth.nil?
        raise API::InitializerError.new(:auth, "must be of class type FeePay::API::Auth") if !self.auth.is_a?(FeePay::API::Auth)
      end
      
      def list(options = {})
        request = HTTPI::Request.new
        request.url = "#{self.class.server_uri}/api/v1/users"
        request.headers = self.generate_headers

        response = HTTPI.get(request)
        
        if !response.error?
          JSON.parse(response.body)
        else
          raise(API::Error.new(response.code, response.body))
        end
      end
      
      def get(uuid, params = {})
        uuid = URI.escape(uuid.to_s)
        
        request = HTTPI::Request.new
        request.url = "#{self.class.server_uri}/api/v1/users/#{uuid}"
        request.query = params.to_query
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
        request.url = "#{self.class.server_uri}/api/v1/users/"
        request.body = params
        request.headers = self.generate_headers

        response = HTTPI.post(request)
        
        if rseponse.code == 201
          true
        elsif !response.error?
          JSON.parse(response.body)
        else
          raise(API::Error.new(response.code, response.body))
        end
      end
      
      def update(uuid, params)
        uuid = URI.escape(uuid.to_s)
        
        request = HTTPI::Request.new
        request.url = "#{self.class.server_uri}/api/v1/users/#{uuid}"
        request.body = params
        request.headers = self.generate_headers

        response = HTTPI.put(request)
        
        if response.code == 204
          true
        elsif !response.error?
          JSON.parse(response.body)
        else
          raise(API::Error.new(response.code, response.body))
        end
      end
      
      def merge(uuid1, uuid2)
        uuid1 = URI.escape(uuid1)
        uuid2 = URI.escape(uuid2)
        
        request = HTTPI::Request.new
        request.url = "#{self.class.server_uri}/api/v1/users/merge/#{uuid1}/#{uuid2}"
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
        request.url = "#{self.class.server_uri}/api/v1/users/#{uuid}"
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