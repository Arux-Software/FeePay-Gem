module FeePay
  module API
    class Auth
      class AccessToken
        attr_accessor :token, :auth
        
        def initialize(options = {})
          self.token = options[:token]
          self.auth = options[:auth]
          
          raise API::InitializerError.new(:token, "can't be blank") if self.token.to_s.empty?
          raise API::InitializerError.new(:auth, "can't be blank") if self.auth.nil?
          raise API::InitializerError.new(:auth, "must be of class type FeePay::API::Auth") if !self.auth.is_a?(FeePay::API::Auth)
        end
        
        def user_data
          if @user_data.nil? and !@token.nil?
            data = {
              :oauth_token => self.token,
              :redirect_uri => self.auth.redirect_uri,
              :client_secret => self.auth.client_secret,
              :client_id => self.auth.client_id
            }
        
            request = HTTPI::Request.new
            request.url = "#{FeePay::API::Auth.server_uri}/user"
            request.query = data
            request.headers = {'User-Agent' => USER_AGENT}

            response = HTTPI.get(request)
        
            if !response.error?
              @user_data = JSON.parse(response.body)
            else
              raise(API::Error.new(response.code, response.body))
            end
          end
          @user_data
        end
      end
      
      def self.server_uri
        if FeePay::API.testmode
          "https://login.pre.feepay.switchboard.io"
        else
          "https://login.feepay.switchboard.io"
        end
      end
      
      attr_accessor :client_id, :client_secret, :redirect_uri, :js_callback, :district_subdomain, :current_user_uuid, :login_mechanism, :element
      
      def initialize(options = {})
        self.client_id = options[:client_id]
        self.client_secret = options[:client_secret]
        self.redirect_uri = options[:redirect_uri]
        self.js_callback = options[:js_callback]
        self.login_mechanism = options[:login_mechanism] || 'redirect'
        self.element = options[:element]
        self.district_subdomain = options[:district_subdomain]
        self.current_user_uuid = options[:current_user_uuid]

        raise API::InitializerError.new(:client_id, "can't be blank") if self.client_id.to_s.empty?
        raise API::InitializerError.new(:client_secret, "can't be blank") if self.client_secret.to_s.empty?
        raise API::InitializerError.new(:redirect_uri, "can't be blank") if self.redirect_uri.to_s.empty?
        raise API::InitializerError.new(:district_subdomain, "can't be blank") if self.district_subdomain.to_s.empty?
      end

      def authorization_url
        %(#{self.class.server_uri}/authorize?client_id=#{self.client_id}&redirect_uri=#{self.redirect_uri})
      end
      
      def access_token(code)
        data = {
          :code => code,
          :grant_type => "authorization_code",
          :redirect_uri => self.redirect_uri,
          :client_secret => self.client_secret,
          :client_id => self.client_id
        }
        
        request = HTTPI::Request.new
        request.url = "#{self.class.server_uri}/access_token"
        request.body = data
        request.headers = {'User-Agent' => USER_AGENT}

        response = HTTPI.post(request)
        
        if !response.error?
          return AccessToken.new(:token => JSON.parse(response.body)['access_token'], :auth => self)
        else
          raise(API::Error.new(response.code, response.body))
        end
      end
      
      def javascript
        options = {
          district: self.district_subdomain,
          element: self.element,
          login: {
            current_uuid: self.current_user_uuid,
            client_id: self.client_id,
            redirect_uri: self.redirect_uri,
            login_mechanism: self.login_mechanism,
            callback: self.js_callback
          }
        }
        return %(new FeePayIOLogin(#{options.to_json});)
      end
      
    end
  end
end