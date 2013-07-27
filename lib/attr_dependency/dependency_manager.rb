require 'delegate'

module AttrDependency

  class DependencyManager

    attr_accessor :owner

    def initialize(owner)
      @owner = owner
    end

    def [](dependency)
      self[dependency] = dependency
    end

    def []=(dependency, klass)
      shadow = NamespaceShadow.new(dependency, Object, klass)

      replace_const_on_owner(shadow.name, shadow.klass)
    end

    private

    def replace_const_on_owner(const_name, new_const)
      with_warnings(nil) do
        owner.send(:remove_const, const_name) if owner.const_defined?(const_name, false)
      end
      
      owner.const_set(const_name, new_const)
    end

    def with_warnings(flag)
      old_verbose, $VERBOSE = $VERBOSE, flag
      yield
    ensure
      $VERBOSE = old_verbose
    end

  end

end
