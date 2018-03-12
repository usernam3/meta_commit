# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [v0.3.0] - 2018-03-12
### Added
- `meta_commit init` command
- `meta_commit version` command
- Column where diff starts
- `whole_file_changed` flag
### Changed
- Configuration file is required to run command
- Diff now expects changes using `ChangeContext` DTO
### Removed
- Default config usage from `MetaCommit::ConfigurationStore`

## [v0.2.0] - 2017-10-25
### Added
- Code documentation
- Contribution guide
- Configuration using `.meta_commit.yml` file
- Handle `MissingRepoError` error 

### Changed
- Dynamically include extensions
- Directory parameter is not longer required for commands, cli receives directory via `--directory` option

### Removed
- Extract ruby specific diffs and parser to separate [extension](https://github.com/meta-commit/ruby_support)
- Extract contracts to separate [gem](https://github.com/meta-commit/contracts)
- Delete base diff class