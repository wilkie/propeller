require 'optparse'

require 'propeller'
require 'propeller/blade'
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

        case ARGV.first
        when 'play'
          fail unless ARGV[1]

          Gruesome::Logo.display

          puts
          puts "--------------------------------------------------------------------------------"
          puts

          Gruesome::Machine.new(ARGV[1]).execute
        else
          config = Propeller::Blade.new
          config.addons.each do |addon|
            puts "Would you like to add #{addon.name} support?"
            puts "#{addon.description}"
            puts "(y/N): "
          end

          settings = []

          config.sections.each do |section|
            if section.is_visible?(settings)
              puts section.name
              section.options.each do |option|
                settings << option.default
                puts option.name
              end
            end
          end
        end
      end
    end
  end
end
