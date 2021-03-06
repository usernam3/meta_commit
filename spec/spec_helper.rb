require 'byebug'
require 'coveralls'
Coveralls.wear!
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'meta_commit'
require 'rspec/mocks'
RSpec.configure do |config|
  config.mock_framework = :rspec
end

require 'support/matchers'
require 'support/config_file_accessor'