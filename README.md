# Propeller

We are reaching a time when we want our applications to be widely deployed by as many people as possible, and we want
to impose little to no technical assumptions on our users. This gem helps people install your applications directly
to several different hosting options and allows them to consistently enable extra features.

## Installation

Add this line to your application's Gemfile:

    gem 'propeller'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install propeller

## Describing a Blade

Place a blade.yml file in your config/ path. This file specifies your application's user
defined settings and keeps track of any addon repositories that a user can elect to
pull.

Within this file, you may specify three things:

### Blade Name

    name: My Blade

### Addons

    addons:
      - name: "addon-name"
        git: ["https://github.com/gitpath",
              "https://mymirror.com/gitpath]
        description: "The text to display to describe this addon to the user."

Addons may also have their own blade.yml that will specify configuration options
specifically for the extra functionality.

### Configuration

    configuration:
      - section: "Main"
        options:
          - name: title
            description: "What will be the title of this node?"
            type: string
            default: "My Node"
      - section: "Appearance"
        options:
          - name: background_color
            description: "What will the background color be?"
            type: integer
            default: 0xffffff

Configuration options specify features that a user can enable or disable. Addons may
include additional configuration options under new sections.

These can be output into a blade.settings.yml using the tool and read into the
application. If no settings are found, the defaults are used from the blade.yml file.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
