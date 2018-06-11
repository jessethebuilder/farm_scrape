# FarmScrape

Use JsScrape for screen scraping with Poltergeist.

Use MachineScrape for scraping raw HTML without JS (out of date, and undocumented)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'farm_scrape', git: 'https://github.com/jessethebuilder/farm_scrape.git'
```

JsScrape requires phantom.js. In a typical Rails application, save phantom.js in /bin.

http://phantomjs.org/download.html

## Usage

Create a new scraper with `JsScrape.new(proxy: false, timeout: 120, phantomjs: nil,
                                        debug: false, phantomjs_debug: false,
                                        phantomjs_options: nil)`

### Params

`proxy` Whether to use a random proxy.

`timeout` In Seconds. Default is 120.

`phantomjs` Provide a path to phantomjs (useful if dev environment is different than production).

`debug` Output gem-specific info for debugging.

`phantomjs_debug` Output phantom.js input for debugging.

`phantomjs_options` Accepts an array of command line options for phantom.js.

### Methods

Exposes a Capybara page object. See: https://github.com/teamcapybara/capybara for details.

`page` returns the Capybara page object.

`html` returns the HTML for the Capybara page object.

`goto(path, retries: 10, sleep_time: nil)` follows path. Will retry as many times as specified by `retries`. `sleep_time` indicates how long to sleep after page retrieval.

`doc` returns Nokogiri object from HTML.

`reset` destroys and rebuilds Capybara object. Useful for dealing with memory overflows.

`cap` alias of `page`.

`noko` alias of `doc`.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
