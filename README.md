# paas-cli

# setup

requires:

- rbenv
- aws-vault
- make

```
gem install bundler
bundle install
```

add the following to your shell profile, _AFTER_ rbenv init

```
export PATH="/path/to/repo/bin:$PATH"
```

# structure

- `/bin` contains the entrypoint which calls `lib/entrypoint.rb`
- `/lib` contains the code
  - `/lib/entrypoint.rb`
    - where execution starts
    - deals with global imports and initial cli parsing
    - it requires each command lazily for speed, even though it is ugly
  - `lib/commands`
    - entrypoint for commands
    - if it is small then it should contain the actual code
    - if the command is extensive/large then it should be broken out into separate files not in the commands directory
  - `lib/aws.rb` is for aws auth
  - `lib/config.rb` is for global config
  - `lib/environment.rb` is for setting up variables for subshells (instead of `make dev/staging` etc
- `/spec` should contain tests but doesn't yet
