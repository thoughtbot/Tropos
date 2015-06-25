<img height="30" width="30" src="http://troposweather.com/assets/images/icon-491180cb.png" alt="Tropos Logo"> Tropos
===============
[![Circle CI](https://circleci.com/gh/thoughtbot/Tropos.svg?style=svg)](https://circleci.com/gh/thoughtbot/Tropos)

Weather and forecasts for humans.
Information you can act on.

Most weather apps throw a lot of information at you
but that doesn't answer the question of "What does it feel like outside?".
Tropos answers this by relating the current conditions
to conditions at the same time yesterday.

[![Download on the App Store](http://troposweather.com/assets/images/app-store-badge-5eb1a238.svg)](https://itunes.apple.com/us/app/tropos-weather-forecasts-for/id955209376?mt=8)

Setup
-----

Run `bin/setup`

This will:

- Install the gem dependencies
- Install the pod dependencies
- Stub Mixpanel and Hockey API keys
- Prompt you for your Forecast API Key. You can get a key from 
  https://developer.forecast.io. You should replace stubbed keys for production 
  builds.

Testing
-----

Run `bin/test`

This will run the tests from the command line, and pipe the result through
[XCPretty][].

Contributing
------------

See the [CONTRIBUTING] document.
Thank you, [contributors]!

[CONTRIBUTING]: CONTRIBUTING.md
[contributors]: https://github.com/thoughtbot/Tropos/graphs/contributors

Need Help?
----------

We offer 1-on-1 coaching.
We can help you with ReactiveCocoa,
getting started writing unit tests,
converting from Objective-C to Swift,
and more.  [Get in touch].

[Get in touch]: http://coaching.thoughtbot.com/ios/?utm_source=github

License
-------

Tropos is Copyright (c) 2015 thoughtbot, inc. It is free software,
and may be redistributed under the terms specified in the [LICENSE] file.

[LICENSE]: /LICENSE

About
-----

![thoughtbot](https://thoughtbot.com/logo.png)

Tropos is maintained and funded by thoughtbot, inc.
The names and logos for thoughtbot are trademarks of thoughtbot, inc.

We love open source software!
See [our other projects][community]
or [hire us][hire] to help build your product.

[community]: https://thoughtbot.com/community?utm_source=github
[hire]: https://thoughtbot.com/hire-us?utm_source=github
[XCPretty]: https://github.com/supermarin/xcpretty
