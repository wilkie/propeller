module Propeller
  module Configuration
    class Option
      attr_accessor :name
      attr_accessor :description
      attr_accessor :type

      def initialize(option_hash)
        @name        = option_hash[:name]
        @description = option_hash[:description]
        @type        = option_hash[:type]
        @if          = option_hash[:if]
      end
    end
  end
end
