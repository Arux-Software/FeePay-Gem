module FeePay
  module API
    class BankInfo
      SERVER_URI = "https://banks.switchboard.io"
      
      def get(routing_number)
        routing_number = URI.escape(routing_number.to_s)

        request = HTTPI::Request.new
        request.url = "#{SERVER_URI}/#{routing_number}"
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