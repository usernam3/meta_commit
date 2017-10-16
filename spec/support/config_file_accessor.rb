def path_to_fixture_of_config(file_name)
  File.join(File.dirname(File.dirname(__FILE__)), 'fixtures', 'configuration', file_name)
end