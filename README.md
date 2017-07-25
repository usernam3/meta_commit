# meta commit
![Travis](https://api.travis-ci.org/usernam3/meta_commit.svg?branch=master)
[![Coverage Status](https://coveralls.io/repos/github/usernam3/meta_commit/badge.svg?branch=master)](https://coveralls.io/github/usernam3/meta_commit?branch=master)

>   Enrich commit diffs with programing language insights


## Description

[![v0.1 demonstration](https://asciinema.org/a/6nlvujsgeoa1xtp9l9qhx8lry.png)](https://asciinema.org/a/6nlvujsgeoa1xtp9l9qhx8lry?autoplay=1)

meta commit - is set of commands for git repository, which extracts useful information from commits and allows to get more insights from usual actions with repository.

Git is universal distributed version control system and works with minimal common units which exist in any file - strings. Meta commit is utility which gives git information about content of files in repo and changes between commits on level of programming language. 


## Installing meta_commit

You can install gem with the following command in a terminal:

    $ gem install meta_commit


## Usage

### Message

``` meta_commit message [--repo=$(pwd)] ```

Prints description of current changes in repository index

### Index

``` meta_commit index [--branch=master] [--repo=$(pwd)] ```

Walks over repository commits and writes meta information to git notes

### Changelog (NOT IMPLEMENTED)

``` meta_commit changelog [--from] [--to] [--repo=$(pwd)] ```

Walks over commits between tags ``` from ``` and ``` to ``` and writes main changes to changelog.md
