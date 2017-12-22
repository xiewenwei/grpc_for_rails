# GrpcForRails

Make grpc server and client easy for rails project.

grpc_for_rails provides a useful grpc_server wrapper and some flexible generators and rake tasks for rails project.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'grpc_for_rails'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install grpc_for_rails

## Usage

Start grpc_server and daemonize it:

    $ bundle exec grpc_server -p grpc_server.pid -d

Stop grpc_server:

    $ kill -TERM `cat grpc_server.pid`

Generate grpc_server configuration scaffold:

    $ bin/rails g grpc:server_conf

It will generate file `<rails root>/config/grpc_for_rails.yaml` which includes all grpc_server configurations `grpc_for_rails` supported. You can change it for your need.

Generate grpc_server services scaffold:

    $ bin/rails g grpc:services

It will generate folder `<rails root>/app/grpc` and sub-folder [`base`, `protos`, `services`] which are the default location for `grpc_for_rails`

Generate grpc_server services ruby codes for grpc proto files:

    $ bin/rails g grpc:protos

It will generate ruby codes based on grpc proto files in `<rails root>/app/grpc/protos`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/xiewenwei/grpc_for_rails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the GrpcForRails project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/xiewenwei/grpc_for_rails/blob/master/CODE_OF_CONDUCT.md).
