#Knife skeleton

Knife plugin to create skeleton integrating chefspec, rubocop, foodcritic, knife test and kitchen.

##Installation

```bash
gem install knife-skeleton
```

##Motivation
The current "knife cookbook create" does not include tests, and many of us need to use chefspec, checkstyle and kitchen.

## Usage Example
Create your cookbook
```
knife skeleton create my-cookbook -o /tmp/cookbooks
```


