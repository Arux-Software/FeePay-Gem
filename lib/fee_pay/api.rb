module FeePay
  module API
    class Error < StandardError
      def initialize(code, message)
        super "(#{code}) #{message}"
      end
    end
  end
end