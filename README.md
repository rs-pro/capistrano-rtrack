# Capistrano::Rtrack

Send capistrano deploy info to Rocket Tracker

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-rtrack'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-rtrack

Add to Capfile:

    require 'capistrano/rtrack'

Add project id to deploy.rb:

    set :rtrack, 'project-slug-from-rtrack'

## Usage

n/a

## Contributing

1. Fork it ( https://github.com/[my-github-username]/capistrano-rtrack/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
