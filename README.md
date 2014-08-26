#Knife skeleton | [![Build Status](https://travis-ci.org/Numergy/knife-skeleton.svg?branch=master)](https://travis-ci.org/Numergy/knife-skeleton)

Knife plugin to create skeleton integrating chefspec, rubocop, foodcritic, knife test and kitchen.

##Installation

With rubygems:
```bash
gem install knife-skeleton
```

With github:
```bash
git clone https://github.com/Numergy/knife-skeleton.git
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

## License and Authors

Authors:
- Pierre Rambaud <pierre.rambaud@numergy.com>
- Antoine Rouyer <antoine.rouyer@numergy.com>

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
