require 'webmock/rspec'
module WebMockWorld
  include WebMock
  include WebMock::Matchers
end
World(WebMockWorld)

$LOAD_PATH << File.expand_path('../../../lib', __FILE__)
require 'roboparser'