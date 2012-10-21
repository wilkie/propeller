# Propeller

We are reaching a time when we want our applications to be widely deployed by as many people as possible, and we want
to impose little to no technical assumptions on our users. This gem helps people install your applications directly
to several different hosting options and allows them to consistently enable extra features.

## End-User Usage

Install:

    $ gem install propeller

Run:

    $ propeller

To configure your application through the command-line.

To list the choices you've made, run:

    $ propeller --selection

Which will display a list of all addons and settings you've selected previously.

To display help on these and other commands:

    $ propeller --help

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
specifically for their own extra functionality.

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

Examples of this file can be found in the repo's test/config directory.

## Application Usage

### Installation

Add this line to your application's Gemfile:

    gem 'propeller'

And then execute:

    $ bundle

### Application Querying

To add support for reading the Blade configurations, add this helper method:

    def has_addon?(addon)
      @blade ||= Propeller::Blade.new
      @blade.selection.addons_include? addon
    end

    def user_options
      @blade ||= Propeller::Blade.new
      @blade.selection
    end

To use:

    user_options[:title] # Get the user defined title

    has_addon? :search # true/false depending on if the user selected the addon

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
