module AttrDependency

  class NamespaceSplitter

    def self.leaf_name(dependency)
      namespaces(dependency).last
    end

    def self.trunk(dependency, root = Object)
      trunk      = namespaces(dependency)[0...-1]
      parent     = root

      trunk.map do |mod_name|
        klass  = parent.const_get(mod_name)
        parent = klass
        [ mod_name, klass ]
      end
    end

    def self.trunk_name(dependency)
      namespaces(dependency).first
    end

    private

      def self.namespaces(dependency)
        dependency.name.split('::')
      end

  end

end
