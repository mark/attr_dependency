require 'delegate'

module AttrDependency

  class NamespaceShadow

    attr_reader :name, :klass

    def initialize(dependency, root, leaf)
      leaf_name = NamespaceSplitter.leaf_name(dependency)
      trunk     = NamespaceSplitter.trunk(dependency, root)

      shadows   = build_shadows(trunk, leaf_name, leaf)
      
      @name     = NamespaceSplitter.trunk_name(dependency)
      @klass    = shadows.first
    end

    private

    def build_shadows(trunk, leaf_name, leaf)
      inner_name  = leaf_name
      inner_class = leaf

      trunk.reverse.map do |mod_name, klass|
        inner_class = shadow_class(klass, inner_name, inner_class)
        inner_name  = mod_name
        inner_class
      end.reverse << leaf
    end

    def shadow_class(klass, const_name, const_class)
      Class.new(DelegateClass(klass)) do
        const_set(const_name, const_class)
      end
    end

  end
  
end
