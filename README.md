#Knife skeleton

Knife plugin to create skeleton integrating chefspec, rubocop, foodcritic, knife test and kitchen.

##Installation

```bash
git clone ssh://git@stash.numer.gy:7999/cd/knife-skeleton.git
cd knife-skeleton
bundle install
rake install
```

##Usage

```bash
$ knife skeleton create -h
knife skeleton create COOKOOK (options)
    -s, --server-url URL             Chef Server URL
        --chef-zero-port PORT        Port to start chef-zero on
    -k, --key KEY                    API Client Key
        --[no-]color                 Use colored output, defaults to false on Windows, true otherwise
    -c, --config CONFIG              The configuration file to use
    -C, --copyright COPYRIGHT        Name of Copyright holder
    -m, --email EMAIL                Email address of cookbook maintainer
    -I, --license LICENSE            License apachev2, gplv2, gplv3, mit or none
    -o, --cookbook-path PATH         The directory where the cookbook will be created
        --defaults                   Accept default values for all questions
    -d, --disable-editing            Do not open EDITOR, just accept the data as is
    -e, --editor EDITOR              Set the editor to use for interactive commands
    -E, --environment ENVIRONMENT    Set the Chef environment
    -F, --format FORMAT              Which format to use for output
    -z, --local-mode                 Point knife commands at local repository instead of server
    -u, --user USER                  API Client Username
        --print-after                Show the data after a destructive operation
    -r, --readme-format FORMAT       Format of the README file, supported formats are 'md', 'rdoc' and 'txt'
    -V, --verbose                    More verbose output. Use twice for max verbosity
    -v, --version                    Show chef version
    -y, --yes                        Say yes to all prompts for confirmation
    -h, --help                       Show this message
```

Create your cookbook

```
knife skeleton create my-cookbook -o /tmp/cookbooks
```

##Motivation
The current "knife cookbook create" does not include tests, and many of us need to use chefspec, checkstyle and kitchen.
