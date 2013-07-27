require 'delegate'

module AttrDependency

  class NamespaceShadow

    attr_reader :outer_shadow, :outer_name

    def initialize(dependency, root, leaf)
      trunk         = NamespaceSplitter.trunk(dependency, root)
      leaf_name     = NamespaceSplitter.leaf(dependency)
      @outer_name   = NamespaceSplitter.trunk_name(dependency)

      shadows       = build_shadows(trunk, leaf_name, leaf)
      shadows << leaf
      
      @outer_shadow = shadows.first
    end

    private

    def build_shadows(trunk, leaf_name, leaf)
      inner_name  = leaf_name
      inner_class = leaf

      trunk.reverse.map do |mod_name, klass|
        inner_class = shadow_class(klass, inner_name, inner_class)
        inner_name  = mod_name
        inner_class
      end.reverse
    end

    def shadow_class(klass, const_name, const_class)
      Class.new(DelegateClass(klass)) do
        const_set(const_name, const_class)
      end
    end

  end
  
end
