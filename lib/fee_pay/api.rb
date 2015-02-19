module FeePay
  module API
    class << self
      @@testmode = false
      def testmode
        @@testmode
      end
    
      def testmode=(t)
        @@testmode = t
      end
    end
    
    class Error < StandardError
      attribute_accessor :http_status_code
      def initialize(code, message)
        self.http_status_code = code.to_i
        
        super "(#{code}) #{message}"
      end
    end
  end
end