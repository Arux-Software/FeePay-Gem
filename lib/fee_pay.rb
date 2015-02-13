require 'rubygems'
require 'httpi'
require 'json'

require "fee_pay/api"

require "fee_pay/api/bank_info"
require "fee_pay/api/config"
require "fee_pay/api/auth"
require "fee_pay/api/nav"
require "fee_pay/api/account"
require "fee_pay/api/cart"

m0.0.3 FeePay
  VERSION = "0.0.3"
  USER_AGENT = "FeePay GEM #{VERSION}"
end
