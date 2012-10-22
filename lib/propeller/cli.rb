require 'optparse'

require 'propeller'
require 'propeller/blade'
require 'propeller/selection'
require 'propeller/configuration/setting'

module Propeller
  class CLI
    BANNER = <<-USAGE
    USAGE

    class << self
      def parse_options
        @opts = OptionParser.new do |opts|
          opts.banner = BANNER.gsub(/^    /, '')

          opts.separator ''
          opts.separator 'Options:'

          opts.on('-h', '--help', 'Display this help') do
            puts opts
            exit 0
          end

          opts.on('-s', '--selection', 'Display the current user selections') do
            config = Propeller::Blade.new
            puts config.selection
            exit 0
          end
        end

        @opts.parse!
      end

      def CLI.run
        begin
          parse_options
        rescue OptionParser::InvalidOption => e
          warn e
          exit -1
        end

        def fail
          puts @opts
          exit -1
        end

        # Default
        config = Propeller::Blade.new

        puts "Configuring #{config.name}..."
        puts ""
        puts "Addons"

        addons = []

        config.addons.each do |addon|
          puts ""
          puts "Would you like to add #{addon.name} support?"
          puts "#{addon.description}"
          print "(y/N): "
          value = readline.chomp
          if value == ""
            value = false
          else
            value = !!value.match(/^y$/i)
          end

          addons << addon if value == true
        end

        sections = config.sections

        addons.each do |a|
          sections.concat a.blade.sections
        end

        settings = []

        sections.each do |section|
          if section.is_visible?(settings)
            puts ""
            puts section.name
            section.options.each do |option|
              puts ""
              puts option.description
              case option.type
              when :bool
                if option.default == true
                  print "(Y/n): "
                else
                  print "(y/N): "
                end

                value = readline.chomp
                if value == ""
                  value = option.default
                else
                  value = !!value.match(/^y$/i)
                end
              when :string
                print " : "
                value = readline.chomp
                if value == ""
                  value = option.default
                end
              when :integer
                if option.max
                  if option.min
                    print "(Within #{option.min}-#{option.max}, Default #{option.default}): "
                  else
                    print "(Max #{option.max}, Default #{option.default}): "
                  end
                else
                  if option.min
                    print "(Min #{option.min}, Default #{option.default}): "
                  else
                    print "(Default #{option.default}): "
                  end
                end
                value = readline.chomp
                if value == ""
                  value = option.default
                else
                  value = value.to_i
                end
              when :decimal
                if option.max
                  if option.min
                    print "(Within #{option.min}-#{option.max}, Default #{option.default}): "
                  else
                    print "(Max #{option.max}, Default #{option.default}): "
                  end
                else
                  if option.min
                    print "(Min #{option.min}, Default #{option.default}): "
                  else
                    print "(Default #{option.default}): "
                  end
                end
                value = readline.chomp
                if value == ""
                  value = option.default
                else
                  value = value.to_f
                end
              end

              settings << Propeller::Configuration::Setting.new(:option => option,
                                                                :value => value)
            end
          end
        end

        puts ""

        puts "Options: "
        addons.map!(&:name)
        configuration = Propeller::Selection.new addons, settings
        puts configuration.to_yaml

        File.open("config/blade.settings.yml", "w+") do |f|
          f.write configuration.to_yaml
          f.write "\n"
        end
      end
    end
  end
end
