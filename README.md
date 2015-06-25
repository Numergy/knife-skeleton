#Knife skeleton | [![Build Status](https://travis-ci.org/Numergy/knife-skeleton.svg?branch=master)](https://travis-ci.org/Numergy/knife-skeleton)

Knife plugin to create skeleton integrating chefspec, rubocop, foodcritic, knife test and kitchen.

##Motivation

The current "knife cookbook create" does not include tests, and many of us need to use chefspec, checkstyle and kitchen.

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

There is no usage instructions! Simply having knife-skeleton installed will automatically override Chef's default `cookbook create` command.

`knife cookbook create COOKBOOK`

### Custom template

It's also possible to override templates_directory by using `:templates_directory` in your `knife.rb` file.
You will be able to add empty directories and all `.erb` files while be copied.

Example:
`knife[:templates_directory] = "PATH"`

## License and Authors

Authors:
- Pierre Rambaud <pierre.rambaud@numergy.com>
- Antoine Rouyer <antoine.rouyer@numergy.com>

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
