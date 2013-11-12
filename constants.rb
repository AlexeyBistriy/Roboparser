
require 'net/https'
require 'net/http'
require 'open-uri'
require 'nokogiri'
require 'watir-webdriver'
require 'rubygems'
require 'net/smtp'
require 'csv'
require 'addressable/uri'
require 'rest-client'
require 'fileutils'

module OpenSSL
  module SSL
    remove_const :VERIFY_PEER
  end
end
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
module Robot
  TRY_COUNT_LOAD=5
end