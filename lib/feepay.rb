require 'rubygems'
require 'httpi'
require 'json'

require "feepay/api"

require "feepay/api/bank_info"
require "feepay/api/config"
require "feepay/api/auth"
require "feepay/api/nav"
require "feepay/api/account"
require "feepay/api/student"
require "feepay/api/cart"

module FeePay
  VERSION = "0.1.1"
  USER_AGENT = "FeePay GEM #{VERSION}"
end

if ENV['FEEPAY_GEM_TEST_MODE'].to_s == "true"
  FeePay::API.testmode = true
end