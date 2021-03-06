require 'propeller/blade'

def addons
  blade = Propeller::Blade.new(:to_env => false)

  addons = blade.addons

  addons.each do |a|
    if blade.addon_enabled? a.name
      a.git.each do |git|
        begin
          gem a.name.to_s, :git => git
          break
        rescue
        end
      end
    end
  end
end

def path_for_addon(addon)
  Gem::Specification::find_by_name(addon.to_s).gem_dir
end
