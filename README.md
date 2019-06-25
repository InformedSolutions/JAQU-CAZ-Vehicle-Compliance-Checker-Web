## JAQU-CAZ-Vehicle-Compliance-Checker Web

### Dependencies
* Ruby 2.6.3
* Ruby on Rails 6.0.0.rc1 - update to 6.0.0 as soon as it is available.
* [GOV.UK Frontend](https://github.com/alphagov/govuk-frontend)
* Other packages listed in Gemfile and package.json files.

### RSpec test
```
rspec
```

### Cucumber test
```
cucumber
```

### Linting
A Ruby static code analyzer and formatter. 
```
rubocop
```

Configures various linters to comply with GOV.UK's style guides.
```
govuk-lint-sass app/javascript
```

### SonarQube inspection
```
sonar-scanner
```

### Variables

* Create .env configuration file from example config.
```
cp .env.example .env
```

* Enter local credentials for database, google analytics etc.:
```
nano .env
```

### CI/CD
1. ``rspec`` - Unit test tool.
2. ``cucumber`` - Test tool.
3. ``rubocop`` - Ruby code analyzer.
4. ``govuk-lint`` - Javascript code analyzer.
5. ``sonarqube`` -  Inspection of code quality.
6. ``brakeman`` - Security vulnerability scanner for Ruby on Rails.
7. ``bundle audit`` - Patch-level verification for bundler.
