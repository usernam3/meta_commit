# meta commit
[![Gem Version](https://badge.fury.io/rb/meta_commit.svg)](https://badge.fury.io/rb/meta_commit)
[![Build Status](https://travis-ci.org/usernam3/meta_commit.svg?branch=master)](https://travis-ci.org/usernam3/meta_commit)
[![Maintainability](https://api.codeclimate.com/v1/badges/ff142cfbcd634e8ad8f1/maintainability)](https://codeclimate.com/github/usernam3/meta_commit/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/usernam3/meta_commit/badge.svg?branch=master)](https://coveralls.io/github/usernam3/meta_commit?branch=master)
[![Inline docs](https://inch-ci.org/github/usernam3/meta_commit.svg?branch=master)](http://inch-ci.org/github/usernam3/meta_commit)

>   Enrich commit diffs with programing language insights


## Description

[![v0.3 demonstration](https://asciinema.org/a/P6kWCq2S4eOpMzEjOAKSHYmyv.png)](https://asciinema.org/a/P6kWCq2S4eOpMzEjOAKSHYmyv?autoplay=1)

[meta commit](https://usernam3.github.io/meta_commit/) - is set of commands for git repository, which extracts useful information from commits and allows to get more insights from usual actions with repository.

Git is universal distributed version control system and works with minimal common units which exist in any file - strings. Meta commit is utility which gives git information about content of repository files and changes between commits on level of programming language. 

## What does meta_commit do ?

After you read the 'Description section' you may still have question 'What does meta_commit do ?'

The answer is - it takes diff of each commit in the repository, parse diff content using programming language parser (taken from list of extensions) and try to understand what changes commit introduced on programming language level (not lines level as git does it).


## Installation

To install gem you need to run:

    $ gem install meta_commit

> You may need to additionally install the cmake to install rugged (ruby bindings to libgit). It is [known issue](https://github.com/usernam3/meta_commit/issues/19).


## Setup

To start using meta_commit, first need to add configuration file to the root of the repository.
To add it, you need to run init command.

    meta_commit init

Or 

    meta_commit init --extensions=ruby_support markdown_support

(*If you want to use [ruby](https://github.com/meta-commit/ruby_support) and [markdown](https://github.com/meta-commit/markdown_support) extensions you will need also to install them by running `gem install meta_commit_ruby_support meta_commit_markdown_support`*)

This command will add `.meta_commit.yml` configuration file with this contents to the repository

```YAML
commands :
  changelog:
    adapter: file
    formatter: keep_a_changelog
  index:
    adapter: git_notes
  message:
    formatter: commit_message

extensions:
  - ruby_support
  - markdown_support
```

This config can be used to customize gem behavior, currently only `extensions` key is used.
Items of `extensions` list are gem names (without `meta_commit_` prefix) that will be loaded.  
[Here](https://github.com/usernam3/meta_commit/blob/master/CONTRIBUTING.md#creating-new-extension) you can get more information about how to create the new extension. 


## Usage

Here you can see usage examples of main meta_commit commands 

### Message

    meta_commit message [--directory=$(pwd)]

Message command prints description of repository working tree staged changes.
Result of execution of this command is string, that is printed to the console and which represents summary of staged changes.

Example :

```zsh
> /repository_folder git diff --cached

diff --git a/lib/meta_commit/changelog/commands/commit_diff_examiner.rb b/lib/meta_commit/changelog/commands/commit_diff_examiner.rb
index 49a8ae1..e8a2bc3 100644
--- a/lib/meta_commit/changelog/commands/commit_diff_examiner.rb
+++ b/lib/meta_commit/changelog/commands/commit_diff_examiner.rb
@@ -8,6 +8,7 @@ module MetaCommit::Changelog
         @parse_command = parse_command
         @ast_path_factory = ast_path_factory
         @diff_factory = diff_factory
+        @some_property = 2 + 2
       end
 
 
@@ -16,7 +17,7 @@ module MetaCommit::Changelog
       # @param [String] left_commit commit id
       # @param [String] right_commit commit id
       # @return [Array<MetaCommit::Contracts::Diff>]
-      def meta(repo, left_commit, right_commit)
+      def examine_meta(repo, left_commit, right_commit)
         diffs = []
         commit_id_old = left_commit.oid
+      def examine_meta(repo, left_commit, right_commit)
         diffs = []
         commit_id_old = left_commit.oid
         commit_id_new = right_commit.oid
@@ -53,6 +54,10 @@ module MetaCommit::Changelog
         end
         diffs
       end
+
+      def examine
+        'method to test'
+      end
     end
   end
 end


> dev/my_projects/meta_commit meta_commit message  
- changes in method initialize 
- changes in CommitDiffExaminer#examine_meta 
- changes in method examine 
```

### Index

    meta_commit index [--directory=$(pwd)]

Index command walks over the repository commits and writes meta information to storage.
Currently the only supported storage adapter is git notes.
So after execution of index command the new git notes will be added to your repository, you will be able to see them using standard `git log` command. 

Example :

```zsh
> /repository_folder git log

commit 1a8ba80e79e7c96fc06d3daf35bbad31cdaab5a4
Author: Stanislav Dobrovolskiy <stasdobrovolskiy@gmail.com>
Date:   Sat Mar 3 02:44:12 2018 +0100

    `init` command implementation #9
    - remove default config usage #9

commit 352b0b3734cc8a940f2133ac73720fc7728e59e7
Author: Stanislav Dobrovolskiy <stasdobrovolskiy@gmail.com>
Date:   Sun Feb 25 22:15:52 2018 +0100

    replace double quotes from note body


> /repository_folder meta_commit index
repository successfully indexed
> /repository_folder git log

commit 1a8ba80e79e7c96fc06d3daf35bbad31cdaab5a4
Author: Stanislav Dobrovolskiy <stasdobrovolskiy@gmail.com>
Date:   Sat Mar 3 02:44:12 2018 +0100

    `init` command implementation #9
    - remove default config usage #9

Notes:
     - changes in method fixture_configuration_file
     - changes in method init
     - changes in method boot_container_with_config
     - change initialization of Errors::MissingConfigError

commit 352b0b3734cc8a940f2133ac73720fc7728e59e7
Author: Stanislav Dobrovolskiy <stasdobrovolskiy@gmail.com>
Date:   Sun Feb 25 22:15:52 2018 +0100

    replace double quotes from note body

Notes:
     - changes in GitNotes#write_to_notes
     - changes in method write_to_notes
```

### Changelog

    meta_commit changelog [--from-tag] [--to-tag] [--directory=$(pwd)] [--filename='CHANGELOG.md'] 

This command walks over commits between ``` from ``` tag and ``` to ``` tag, examine changes and write them to changelog file

Example :

```zsh

> /repository_folder meta_commit changelog v0.2.0 v0.3.0
added version [v0.3.0] to CHANGELOG.md

> /repository_folder cat CHANGELOG.md
...

## [v0.3.0] - 2018-03-03
### Added
- add Maintainability
- create class SomeServiceNEWNAME
- Configuration,DataObject added to SomeModule
- changes in method meta
- changes in method init
- changes in method version
- changes in method boot_container_with_config
- changes in method load_builtin_extension
- changes in method create_contextual_node
- changes in method collect_path_to_ast_at_line
- changes in method lines?
- changes in method covers_line?
- changes in method create_diff
- changes in method change_context
- changes in method organize_lines
- changes in method write_to_notes
- changes in method examine_diff
- changes in method index_meta
- changes in method compute_column
### Changed
- change README.md
- change Inline docs
- changes in CommitDiffExaminer#meta
- change initialization of Errors::MissingConfigError
- changes in ContextualAstNodeFactory#create_contextual_node
- changes in ContextualAstNodeFactory#covers_line?
- changes in DiffFactory#create_diff
- changes in GitNotes#write_to_notes
- changes in DiffExaminer#examine_diff
- changes in DiffIndexExaminer#index_meta
### Removed
- changes in method meta
- changes in method boot_container_with_config
- changes in method create_ast_path
- changes in method get_ast_at_line
- changes in method covers_line
- changes in method examine_diff
- changes in method index_meta
- remove module Models

...

```


##  Extensions

Extensions are very important part of meta_commit utility, they are used to parse source files and see difference between commits.
Idea is that each extension should add new capabilities and knowledge on how to work with the new file extensions.
Without extensions the meta_commit is just a script which traverses git repository and read files.

[Here](https://github.com/usernam3/meta_commit/blob/master/CONTRIBUTING.md#creating-new-extension) you can get more information about how to create new extension. 
