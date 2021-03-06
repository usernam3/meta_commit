module MetaCommitWorld
  @git_repo_name
  @configuration_name

  def git_repo_name(repo_name)
    @git_repo_name=repo_name
  end

  def configuration_name(config_name)
    @configuration_name=config_name
  end

  def directory_option
    repository_fixtures = File.join(File.dirname(File.dirname(__FILE__)), 'tmp', 'repositories')
    full_repo_path = File.join(repository_fixtures, @git_repo_name)
    "--directory=#{full_repo_path}"
  end

  def configuration_option
    "" unless @configuration_name.nil?
  end

  def command_options
    command_options=[]
    command_options << directory_option unless @git_repo_name.nil?
    command_options.join(' ')
  end

  def fixture_changelog_file_path(file)
    File.join(File.dirname(File.dirname(__FILE__)), 'fixtures', 'changelogs', file)
  end

  def fixture_note_file_path(repository, object_id)
    File.join(File.dirname(File.dirname(__FILE__)), 'fixtures', 'notes', repository, object_id)
  end

  def fixture_configuration_file(file_name)
    File.join(File.dirname(File.dirname(__FILE__)), 'fixtures', 'configurations', file_name)
  end

  def repository_file_path(repository, file)
    File.join(File.dirname(File.dirname(__FILE__)), 'tmp', 'repositories', repository, file)
  end
end

World(MetaCommitWorld)