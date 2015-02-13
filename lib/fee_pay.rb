require 'rubygems'
require 'httpi'
require 'json'

require "fee_pay/api"

require "fee_pay/api/bank_info"
require "fee_pay/api/config"
require "fee_pay/api/auth"
require "fee_pay/api/account"
require "fee_pay/api/cart"

module FeePay
  VERSION = "0.0.2"
  USER_AGENT = "FeePay GEM #{VERSION}"
end
