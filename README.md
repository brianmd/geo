[![Build Status](https://api.travis-ci.org/brianmd/geo.png?branch=master)](https://travis-ci.org/brianmd/geo)  [![Coverage Status](https://coveralls.io/repos/brianmd/geo/badge.png?branch=master&service=github)](https://coveralls.io/github/brianmd/geo?branch=master)

# Geo

![Alt text](docs/verve.png?raw=true "Class Diagram")

This repository is for the Verve
[coding challenge](https://github.com/VerveWireless/software-challenge),
but I took it as an opportunity
to experiment with the virtus gem (learned using active_model is useful
in conjuction it), and write my first react.js code.

The example file does not have the same columns as the description, so my models
contain the subset of the fields, and assume the data will arrive in the format
of the example file.

The rows of the example file are unique via street, latitude, and longitude, so
those are what I use as the key. Should a second row occur with the same key,
the original row will be updated.

## Installation

Run this from the command line:

```sh
gem 'geo', :git => 'git://github.com/brianmd/geo.git'
```


## Usage

```sh
geo_runner
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/geo.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

