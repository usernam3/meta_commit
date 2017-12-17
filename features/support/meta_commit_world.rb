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
    repository_fixtures = File.join(File.dirname(File.dirname(__FILE__)), 'fixtures', 'repositories')
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
end

World(MetaCommitWorld)