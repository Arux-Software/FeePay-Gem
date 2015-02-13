module FeePay
  module API
    class Auth
      def self.server_uri
        if FeePay::API.testmode
          "https://login.pre.feepay.switchboard.io"
        else
          "https://login.feepay.switchboard.io"
        end
      end
      
      attr_accessor :client_id, :client_secret, :redirect_uri, :js_callback, :district_subdomain, :current_user_id
      
      def initialize(options = {})
        self.client_id = options[:client_id]
        self.client_secret = options[:client_secret]
        self.redirect_uri = options[:redirect_uri]
        self.js_callback = options[:js_callback]
        self.district_subdomain = options[:district_subdomain]
        self.current_user_uuid = options[:current_user_uuid]
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
          JSON.parse(response.body)['access_token']
        else
          raise(API::Error.new(response.code, response.body))
        end
      end
      
      def javascript
        options = {
          district: @district,
          login: {
            current_uuid: @current_uuid,
            client_id: self.client_id,
            redirect_uri: self.redirect_uri,
            callback: self.js_callback
          }
        }
        return %(new FeePayIOLogin(#{options.to_json});)
      end
      
    end
  end
end