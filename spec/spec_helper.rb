# coding: utf-8
require 'webmock/rspec'
RSpec::Runner.configure do |config|
  config.include WebMock
end
require 'vcr'
VCR.configure do |c|
  c.cassette_library_dir = 'vcr_cassettes'
  c.hook_into :webmock
end
require 'roboparser'
