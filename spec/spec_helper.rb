# coding: utf-8
#require 'webmock/rspec'
#WebMock.disable_net_connect!(allow_localhost: true)


require 'vcr'
VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
end
require 'roboparser'
