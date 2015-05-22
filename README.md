# Tropos #

## Setup ##

Run `bin/setup`

This will:

- Install the gem dependencies
- Install the pod dependencies
- Create `Secrets.h`. `TRForecastAPIKey` is the only one required for the
  application to run. You can get a key from https://developer.forecast.io. You
  should include all keys for production builds.

## Testing ##

Run `bin/test`

This will run the tests from the command line, and pipe the result through
[XCPretty][].

[XCPretty]: https://github.com/supermarin/xcpretty
