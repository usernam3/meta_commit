require 'coveralls'
Coveralls.wear!
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'meta_commit'
require 'rspec/mocks'
RSpec.configure do |config|
  config.mock_framework = :rspec
end
RSpec::Matchers.define :string_contains_single_occurrence_of do |substring|
  match {|actual| actual.scan(/#{substring}/).count == 1}
end

require 'support/config_file_accessor'