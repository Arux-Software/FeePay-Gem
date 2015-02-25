module FeePay
  module API
    class Student < Account

      def lookup_district_student_id(params)
        # accepted lookup attributes
        # firstname & lastname & birthdate
        # state_student_id
        request = HTTPI::Request.new
        request.url = "#{self.class.server_uri}/api/v1/students/lookup/district_student_id/#{URI.escape(self.auth.district_subdomain)}"
        request.query = params
        request.headers = self.generate_headers

        response = HTTPI.get(request)
        
        if !response.error?
          JSON.parse(response.body)
        else
          raise(API::Error.new(response.code, response.body))
        end
      end
      
      def lookup_state_student_id(params)
        # accepted lookup attributes
        # firstname & lastname & birthdate
        # district_student_id
        request = HTTPI::Request.new
        request.url = "#{self.class.server_uri}/api/v1/students/lookup/state_student_id/#{URI.escape(self.auth.district_subdomain)}"
        request.query = params
        request.headers = self.generate_headers

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