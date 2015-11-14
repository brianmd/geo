[![Build Status](https://api.travis-ci.org/brianmd/geo.png?branch=master)](https://travis-ci.org/brianmd/geo)  [![Coverage Status](https://coveralls.io/repos/brianmd/geo/badge.png?branch=master&service=github)](https://coveralls.io/github/brianmd/geo?branch=master)

# Geo

![Alt text](docs/screenshot.png?raw=true "Screenshot")

This repository is for the Verve
[coding challenge](https://github.com/VerveWireless/software-challenge).

The example file format is slightly different than the challenge description. This uses the example file format (and puts it into the textarea as a default, which may be modified before submission.) The first five rows are added upon startup.

![Alt text](docs/verve.png?raw=true "Class Diagram")

## Usage

Run this from the command line:

```sh
git clone https://github.com/brianmd/geo.git
cd geo
bundle install
bundle exec ruby lib/webapp.rb

and open http://localhost:8080/index.html in a browser

Note: you must have redis running on localhost.
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
