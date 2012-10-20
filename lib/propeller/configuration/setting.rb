module Propeller
  module Configuration
    class Setting
      require 'json'

      attr_accessor :option
      attr_accessor :value

      def initialize(value_hash)
        @option = value_hash[:option]
        @value  = value_hash[:value]
      end

      def to_yaml
        "#{@option.name.to_json}: #{@value.to_json}"
      end

      def to_json
        "#{@option.name.to_json}: #{@value.to_json}"
      end

      def to_s
        to_yaml
      end
    end
  end
end
