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

      attr_accessor :auth, :access_token
      
      def initialize(options = {})
        self.auth         = options[:auth]
        self.access_token = options[:access_token]
        
        raise API::InitializerError.new(:auth_or_access_token, "can't be blank") if self.auth.nil? and self.access_token.nil?
        raise API::InitializerError.new(:auth, "must be of class type FeePay::API::Auth") if self.auth and !self.auth.is_a?(FeePay::API::Auth)
        raise API::InitializerError.new(:access_token, "must be of class type FeePay::API::Auth::AccessToken") if self.access_token and !self.access_token.is_a?(FeePay::API::Auth::AccessToken)
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
        request.query = URI.encode_www_form(params)
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
      
      def owner(params = {})
        raise API::RequirementError.new(:access_token, "can't be blank") if self.access_token.nil?

        request = HTTPI::Request.new
        request.url = "#{self.class.server_uri}/api/v1/users/owner"
        request.query = URI.encode_www_form(params)
        request.headers = self.generate_headers

        response = HTTPI.get(request)
        
        if !response.error?
          JSON.parse(response.body)
        else
          raise(API::Error.new(response.code, response.body))
        end
      end
      
      # TODO:: create mapping for relationships api endpoints
      
      protected
      
      def generate_headers
        if self.access_token
          {'User-Agent' => USER_AGENT, 'Authorization' => self.access_token.token}
        else
          {'User-Agent' => USER_AGENT, 'Client-Secret' => self.auth.client_secret, 'Client-Id' => self.auth.client_id}
        end
      end

    end
  end
end