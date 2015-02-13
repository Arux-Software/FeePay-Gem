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
      def initialize(code, message)
        super "(#{code}) #{message}"
      end
    end
  end
end