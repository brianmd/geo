[![Build Status](https://api.travis-ci.org/brianmd/geo.png?branch=master)](https://travis-ci.org/brianmd/geo)  [![Coverage Status](https://coveralls.io/repos/brianmd/geo/badge.png?branch=master&service=github)](https://coveralls.io/github/brianmd/geo?branch=master)

# Geo

![Alt text](docs/screenshot.png?raw=true "Screenshot")

This repository is for the Verve
[coding challenge](https://github.com/VerveWireless/software-challenge),
but I took it as an opportunity
to experiment with the virtus gem and write my first react.js code.

Using sinatra rather than rails as this is a small, self-contained project.
Rails has a good transpiling framework -- not sure how to do the jsx
transpiling in sinatra. Spent about two minutes with babel, but then went with the jsxtransformer.

The example file does not have the same columns as the coding challenge description,
so my models contain the superset, but am showing the subset.

The rows of the example file are unique via street, latitude, and longitude, so
those are what I use as the key. Should a second row occur with the same key,
the original row will be updated.

Added a bit of google map api code at the last minute.
Would like to have allowed clicking of a business to pull up
a modal with a map of that location, but ran out of time.

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
