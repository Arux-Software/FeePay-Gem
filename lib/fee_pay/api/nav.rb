module FeePay
  module API
    class Nav

      attr_accessor :auth

      def initialize(options = {})
        self.auth = options[:auth]

        raise API::InitializerError.new(:auth, "can't be blank") if self.auth.nil?
        raise API::InitializerError.new(:auth, "must be of class type FeePay::API::Auth") if !self.auth.is_a?(FeePay::API::Auth)
      end

      def javascript
        options = {
          district: self.auth.district_subdomain,
          login: {
            current_uuid: self.auth.current_user_uuid,
            client_id: self.auth.client_id,
            redirect_uri: self.auth.redirect_uri,
            callback: self.auth.js_callback
          }
        }
        return %(new FeePayIONav(#{options.to_json});)
      end

    end
  end
end