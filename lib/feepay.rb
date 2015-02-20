require 'rubygems'
require 'httpi'
require 'json'

require "feepay/api"

require "feepay/api/bank_info"
require "feepay/api/config"
require "feepay/api/auth"
require "feepay/api/nav"
require "feepay/api/account"
require "feepay/api/cart"

module FeePay
  VERSION = "0.1.0"
  USER_AGENT = "FeePay GEM #{VERSION}"
end
