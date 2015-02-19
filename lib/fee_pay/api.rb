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
      attr_accessor :http_status_code
      def initialize(code, message)
        self.http_status_code = code.to_i
        
        super "(#{code}) #{message}"
      end
    end
    
    class InitializerError < StandardError
      def initialize(method, message)        
        super "#{method} #{message}"
      end
    end
  end
end