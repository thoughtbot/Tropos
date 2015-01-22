# CarlWeathers #

## Setup ##

Create `Secrets.h` and include the necessary contents

```
#define TROPOS_HOCKEY_IDENTIFIER @""
```

Run `bin/setup`

This will:

 - Install the gem dependencies
 - Install the pod dependencies

## Testing ##

Run `bin/test`

This will run the tests from the command line, and pipe the result through
[XCPretty][].

[XCPretty]: https://github.com/supermarin/xcpretty
