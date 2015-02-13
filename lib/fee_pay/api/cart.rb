module FeePay
  module API
    class Cart
      SERVER_URI = "https://cart.feepay.switchboard.io"
      
      attr_accessor :auth, :access_token, :district_subdomain
      
      def initialize(options = {})
        self.auth = options[:auth]
        self.access_token = options[:access_token]
        self.district_subdomain = options[:district_subdomain]
      end
      
      def get(uuid = nil)
        if uuid
          path = %(/api/#{URI.escape(uuid)})
        else
          path = %(/api/#{self.generate_cart_path})
        end
        
        request = HTTPI::Request.new
        request.url = "#{SERVER_URI}#{path}"
        request.headers = self.generate_headers

        response = HTTPI.get(request)
        
        if !response.error?
          JSON.parse(response.body)
        else
          raise(API::Error.new(response.code, JSON.parse(response.body)[:message]))
        end
      end
      
      def get_status
        path = %(/api/#{self.generate_cart_path}/status)
        
        request = HTTPI::Request.new
        request.url = "#{SERVER_URI}#{path}"
        request.headers = self.generate_headers

        response = HTTPI.get(request)
        
        if !response.error?
          JSON.parse(response.body)
        else
          raise(API::Error.new(response.code, JSON.parse(response.body)[:message]))
        end
      end
      
      def get_items
        path = %(/api/#{self.generate_cart_path}/items)
        
        request = HTTPI::Request.new
        request.url = "#{SERVER_URI}#{path}"
        request.headers = self.generate_headers

        response = HTTPI.get(request)
        
        if !response.error?
          JSON.parse(response.body)
        else
          raise(API::Error.new(response.code, JSON.parse(response.body)[:message]))
        end
      end
      
      def get_item(item_identifier)
        path = %(/api/#{generate_cart_path}/items/#{item_identifier})
        
        request = HTTPI::Request.new
        request.url = "#{SERVER_URI}#{path}"
        request.headers = self.generate_headers

        response = HTTPI.get(request)
        
        if !response.error?
          JSON.parse(response.body)
        else
          raise(API::Error.new(response.code, JSON.parse(response.body)[:message]))
        end
      end
      
      def add_item(params)
        path = %(/api/#{generate_cart_path}/items)
        
        request = HTTPI::Request.new
        request.url = "#{SERVER_URI}#{path}"
        request.body = params
        request.headers = self.generate_headers

        response = HTTPI.post(request)
        
        if !response.error?
          JSON.parse(response.body)
        else
          raise(API::Error.new(response.code, JSON.parse(response.body)[:message]))
        end
      end
      
      def update_item(item_identifier, params)
        path = %(/api/#{generate_cart_path}/items/#{item_identifier})
        
        request = HTTPI::Request.new
        request.url = "#{SERVER_URI}#{path}"
        request.body = params
        request.headers = self.generate_headers

        response = HTTPI.put(request)
        
        if !response.error?
          JSON.parse(response.body)
        else
          raise(API::Error.new(response.code, JSON.parse(response.body)[:message]))
        end
      end
      
      def delete_item(item_identifier)
        path = %(/api/#{generate_cart_path}/items/#{item_identifier})
        
        request = HTTPI::Request.new
        request.url = "#{SERVER_URI}#{path}"
        request.headers = self.generate_headers

        response = HTTPI.delete(request)
        
        if !response.error?
          JSON.parse(response.body)
        else
          raise(API::Error.new(response.code, JSON.parse(response.body)[:message]))
        end
      end
      
      private
      
      def generate_cart_path
        %(#{URI.escape(self.district_subdomain)}/#{URI.escape(self.access_token)})
      end
      
      def generate_headers
        {'User-Agent' => USER_AGENT, 'Client-Id' => self.auth.client_id}
      end
    end
  end
end