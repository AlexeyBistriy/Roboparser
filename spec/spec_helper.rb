require 'webmock/rspec'
Spec::Runner.configure do |config|
  config.include WebMock
end
require 'roboparser'
