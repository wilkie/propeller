require 'optparse'

require 'propeller'
require 'propeller/blade'
require 'propeller/selection'
require 'propeller/configuration/setting'

module Propeller
  class CLI
    BANNER = <<-USAGE
    Usage:
      gruesome play STORY_FILE

    Description:
      The 'play' command will start a session of the story given as STORY_FILE

    Example:
      gruesome play zork1.z3

    USAGE

    class << self
      def parse_options
        @opts = OptionParser.new do |opts|
          opts.banner = BANNER.gsub(/^    /, '')

          opts.separator ''
          opts.separator 'Options:'

          opts.on('-h', '--help', 'Display this help') do
            puts opts
            exit
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

        config = Propeller::Blade.new

        puts "Configuring #{config.name}..."
        puts ""
        puts "Addons"

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
        end

        settings = []

        config.sections.each do |section|
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

          puts ""

          puts "Options: "
          configuration = Propeller::Selection.new settings
          puts configuration.to_yaml

          puts
          puts configuration[:multi_user]

          File.open("config/blade.settings.yml", "w+") do |f|
            f.write configuration.to_yaml
            f.write "\n"
          end
        end
      end
    end
  end
end
