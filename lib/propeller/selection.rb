module Propeller
  class Selection
    def initialize(settings)
      @settings = {}

      settings.each do |setting|
        @settings[setting.option.name] = setting
      end
    end

    def [](name)
      @settings[name]
    end

    def to_yaml
    end

    def to_json
    end

    def to_s
      @settings.values.map{|setting| setting.to_s}.join("\n")
    end
  end
end
