# meta commit
[![Gem Version](https://badge.fury.io/rb/meta_commit.svg)](https://badge.fury.io/rb/meta_commit)
![Travis](https://api.travis-ci.org/usernam3/meta_commit.svg?branch=master)
[![Coverage Status](https://coveralls.io/repos/github/usernam3/meta_commit/badge.svg?branch=master)](https://coveralls.io/github/usernam3/meta_commit?branch=master)
[![Inline docs](http://inch-ci.org/github/usernam3/meta_commit.svg?branch=master)](http://inch-ci.org/github/usernam3/meta_commit)

>   Enrich commit diffs with programing language insights


## Description

[![v0.2 demonstration](https://asciinema.org/a/svV2TBICPgp7pOWneRI30WDel.png)](https://asciinema.org/a/svV2TBICPgp7pOWneRI30WDel?autoplay=1)

meta commit - is set of commands for git repository, which extracts useful information from commits and allows to get more insights from usual actions with repository.

Git is universal distributed version control system and works with minimal common units which exist in any file - strings. Meta commit is utility which gives git information about content of files in repo and changes between commits on level of programming language. 


## Installing meta_commit

You can install gem with the following command in a terminal:

    $ gem install meta_commit


## Setup

To setup ```meta_commit``` gem for your repository you need to add configuration file to root of repo.
Currently meta commit expects configuration file with name `.meta_commit.yml` of this format : 

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
  - extension2
  - extension3
  - extension4
```

This config can be used to change gem behavior, currently it supports only `extensions` key.
Elements of `extensions` list are gem names (without `meta_commit_` prefix) that will be loaded.
[Here](https://github.com/usernam3/meta_commit/blob/master/CONTRIBUTING.md) you can get more information about how to create new extension. 


## Usage

### Message

    meta_commit message [--directory=$(pwd)]

Prints description of current changes in repository index

### Index

    meta_commit index [--directory=$(pwd)]

Walks over repository commits and writes meta information to git notes

### Changelog

    meta_commit changelog [--from-tag] [--to-tag] [--directory=$(pwd)] [--filename='CHANGELOG.md'] 

Walks over commits between tags ``` from ``` and ``` to ``` and writes changes to changelog file
