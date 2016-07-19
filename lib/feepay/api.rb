module FeePay
  module API
    class << self
      @@mode = :standard
      [:test, :dev, :standard].each do |m|
        define_method("#{m}mode?") do
          @@mode == m
        end
        
        define_method("#{m}mode") do
          @@mode == m
        end
        
        define_method("#{m}mode=") do |b|
          @@mode = b ? m : :standard
        end
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