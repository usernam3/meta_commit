RSpec::Matchers.define :string_contains_single_occurrence_of do |substring|
  match {|actual| actual.scan(/#{substring}/).count == 1}
end
