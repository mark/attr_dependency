module AttrDependency

  module DependencySetter

    def dependencies
      @__dependency_manager__ ||= DependencyManager.new(self)  
    end

  end

end
