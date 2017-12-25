Before do
  # Add repository fixtures to /tmp
  repository_fixtures=File.join(File.dirname(File.dirname(__FILE__)), 'fixtures', 'repositories', '.')
  tmp_repository_fixtures=File.join(File.dirname(File.dirname(__FILE__)), 'tmp', 'repositories')
  FileUtils.cp_r(repository_fixtures, tmp_repository_fixtures)

  # Create .git directories
  Dir.glob(File.join(tmp_repository_fixtures, '*')).each do |path_to_fixture_of_repository|
    old_git_folder=File.join(path_to_fixture_of_repository, '.checkout_git')
    new_git_folder=File.join(path_to_fixture_of_repository, '.git')
    FileUtils.copy_entry(old_git_folder, new_git_folder)
  end
end

After do
  # Remove repository fixtures from /tmp
  tmp_repository_fixtures=File.join(File.dirname(File.dirname(__FILE__)), 'tmp', 'repositories')
  FileUtils.rm_rf(tmp_repository_fixtures)
end