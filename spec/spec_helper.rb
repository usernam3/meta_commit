$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'meta_commit'
require 'rspec/mocks'
RSpec.configure do |config|
  config.mock_framework = :rspec
end