## JAQU-CAZ-Vehicle-Compliance-Checker Web

### Dependencies
* Ruby 2.6.3
* Ruby on Rails 6.0.0.rc1 - update to 6.0.0 as soon as it is available.
* [GOV.UK Frontend](https://github.com/alphagov/govuk-frontend)
* Other packages listed in Gemfile and package.json files.

### Specs test
```
bundle exec rspec
```

### Linting
A Ruby static code analyzer and formatter. 
```
rubocop
```

Configures various linters to comply with GOV.UK's style guides.
```
bundle exec govuk-lint-sass app/javascript
```

### Cucumber test
```
rails cucumber
```

### Variables

* Create .env configuration file from example config.
```
cp .env.example .env
```

* Enter local credentials for database, Redis url etc.:
```
nano .env
```

### CI/CD
1. ``rubocop`` - Ruby static code analyzer and formatter.
2. ``brakeman`` - ROR static analysis security vulnerability scanner.
3. ``bundle audit check --update`` - Patch-level verification for bundler.
4. ``rspec`` - Unit test tool.
