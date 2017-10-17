## How to contribute to meta commit project

### Development environment

Fork, then clone the repo:

    git clone git@github.com:your-username/meta_commit.git

Set up your machine:

    ./bin/setup

Make sure the tests pass:

    rake

Create your feature branch 

    git checkout -b my-new-feature

Make your change. Add tests for your change. Make the tests pass:

    rake

Push to the branch

    git push origin my-new-feature

Create a new Pull Request


### How it works

Task of meta_commit gem is to :

1. Walk over changes presented in commit
2. Parse content of changes using parsers from extensions
3. Find matching diffs for parsed changes
4. Handle diffs (print as string, save to storage or return)


### Creating new extension

Extension is a gem that adds new parsers or diffs to core meta commit gem.

To be autoloaded by meta commit core it must follow agreements :

-   Gem name matches `/^meta_commit_/` regex
-   Gem has class with name `MetaCommit::Extension::#{ExtensionName}::Locator` (`ExtensionName` without `meta_commit_` prefix)
    -   Which returns array of parser classes on `MetaCommit::Extension::#{ExtensionName}::Locator#parsers`
    -   Which returns array of diff classes on `MetaCommit::Extension::#{ExtensionName}::Locator#diffs`

Meta commit uses contracts to interact with extensions, you can check this contracts [here](https://github.com/meta-commit/contracts) .

To understand better how to build extension you can check [extension that adds ruby language support](https://github.com/meta-commit/contracts).


---


By participating in this project, you agree to abide by the [code of conduct](https://github.com/usernam3/meta_commit/blob/master/CODE_OF_CONDUCT.md).
