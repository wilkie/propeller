module Propeller
  module Configuration
    class Section
      attr_accessor :name
      attr_accessor :options

      def initialize(section_hash)
        @name    = section_hash[:section]
        @options = section_hash[:options]
        @if      = section_hash[:if]
      end

      def is_visible?(settings)
        return true if @if.nil?

        exists = settings.index do |setting|
          if @if == setting.option.name
            case setting.option.type
            when :bool
              setting.value == true
            when :integer, :decimal
              setting.value > 0
            when :string
              setting.value.length > 0
            end
          end
        end

        not exists.nil?
      end
    end
  end
end
