# About GoPay

GoPay is a library making it easy to access "GoPay.cz":http://www.gopay.cz paygate from Ruby.

## Quick Start

GoPay is distributed primarily via gem, but it can be also placed to "vendor/plugins" as a Rails plugin.

## Configuration

First, you have to include it in your Gemfile or install manually and require:

```ruby
# Gemfile
gem 'gopay'

# Manually
gem install gopay
require 'gopay'
```

GoPay can be configured within a config block (placed in config/initializers/gopay.rb for Rails, for instance):

```ruby
GoPay.configure do |config|
  config.environment = :test
  config.goid   = "XXXXX"
  config.secret = "XXXXX"
  config.success_url = "http://example.com/success"
  config.failed_url  = "http://example.com/failed"
end
```

## Usage

While gem is under decent construction, I removed old usage example in favor of tests that are actual as hell! ;)

Big thanks to @Pepan, who moved gem to 1.9.3!
