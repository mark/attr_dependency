module AttrDependency

  def attr_dependency(klass)
    self.extend DependencySetter unless respond_to?(:dependencies)
    self.dependencies[klass]
  end

end
