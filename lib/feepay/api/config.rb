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

      attr_accessor :auth

      def initialize(options = {})
        self.auth = options[:auth]

        raise API::InitializerError.new(:auth, "can't be blank") if self.auth.nil?
        raise API::InitializerError.new(:auth, "must be of class type FeePay::API::Auth") if !self.auth.is_a?(FeePay::API::Auth)
      end

      def get(subdomain_or_sn)
        subdomain_or_sn = URI.escape(subdomain_or_sn.to_s)

        request = HTTPI::Request.new
        request.url = "#{self.class.server_uri}/v1/customers/#{subdomain_or_sn}"
        request.headers = self.generate_headers

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
        request.url = "#{self.class.server_uri}/v1/customers/by/#{key}/#{value}"
        request.headers = self.generate_headers

        response = HTTPI.get(request)

        if !response.error?
          JSON.parse(response.body)
        else
          raise(API::Error.new(response.code, response.body))
        end
      end

      protected

      def generate_headers
        {'User-Agent' => USER_AGENT, 'Client-Secret' => self.auth.client_secret, 'Client-Id' => self.auth.client_id}
      end

    end
  end
end
