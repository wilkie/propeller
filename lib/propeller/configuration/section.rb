module Propeller
  module Configuration
    class Section
      attr_accessor :name
      attr_accessor :options

      def initialize(section_hash)
        @name    = section_hash[:name]
        @options = section_hash[:options]
      end
    end
  end
end
