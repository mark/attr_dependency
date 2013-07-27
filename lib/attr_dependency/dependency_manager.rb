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
      const = dependency.name

      namespaces = const.split('::')

      # shadows = NamespaceShadow.new(dependency, Object, klass)

      # outer_name   = shadows.outer_name
      # outer_shadow = shadows.outer_shadow

      if namespaces.length == 3
        outer_name    = namespaces[0]
        outer_class   = Class.const_get(outer_name)

        middle_name   = namespaces[1]
        middle_class  = outer_class.const_get(middle_name)

        inner_name    = namespaces[2]
        inner_class   = klass

        middle_shadow = shadow_class(middle_class, inner_name,  inner_class)
        outer_shadow  = shadow_class(outer_class,  middle_name, middle_shadow)
      elsif namespaces.length == 2
        inner_name   = namespaces.last
        inner_class  = klass

        outer_name   = namespaces.first
        outer_class  = Class.const_get(outer_name)
        outer_shadow = shadow_class(outer_class, inner_name, inner_class)
      else
        outer_name   = const
        outer_shadow = klass
      end

      replace_const(outer_name, outer_shadow)
    end

    def replace_const(const_name, new_const)
      with_warnings(nil) do
        owner.send(:remove_const, const_name) if owner.const_defined?(const_name, false)
      end
      
      owner.const_set(const_name, new_const)
    end

    private

    def shadow_class(klass, const_name, const_class)
      Class.new(DelegateClass(klass)) do
        const_set(const_name, const_class)
      end
    end


    def with_warnings(flag)
      old_verbose, $VERBOSE = $VERBOSE, flag
      yield
    ensure
      $VERBOSE = old_verbose
    end

  end

end
