# Capistrano::Rtrack

Отправка информации о деплоях из capistrano в rtrack

This is an iternal gem and is of no use to you unless you know what's it for :)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-rtrack', require: false
```

```require: false``` part is *important*

And then execute:

    $ bundle

Add to Capfile:

    require 'capistrano/rtrack'

Добавьте ключ со страницы настроек проекта (внизу страницы) в deploy.rb:

    set :rtrack_token, 'токен'

## Usage

Перед подключением этого гема НЕОБХОДИМО привязать проект к гитлабy.

## Contributing

1. Fork it ( https://github.com/rs-pro/capistrano-rtrack/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
