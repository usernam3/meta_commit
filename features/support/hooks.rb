Before do
  # Create .git directories
  repository_fixtures=File.join(File.dirname(File.dirname(__FILE__)), 'fixtures', 'repositories', '*')
  Dir.glob(repository_fixtures).each do |path_to_fixture_of_repository|
    old_git_folder=File.join(path_to_fixture_of_repository, '.checkout_git')
    new_git_folder=File.join(path_to_fixture_of_repository, '.git')
    FileUtils.rmdir(new_git_folder)
    FileUtils.copy_entry(old_git_folder, new_git_folder)
  end
end

After do
  # Remove .git directories
  repository_fixtures=File.join(File.dirname(File.dirname(__FILE__)), 'fixtures', 'repositories', '*')
  Dir.glob(repository_fixtures).each do |path_to_fixture_of_repository|
    new_git_folder=File.join(path_to_fixture_of_repository, '.git')
    FileUtils.rm_rf(new_git_folder)
  end
end