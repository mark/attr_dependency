require 'spec_helper'
require 'securerandom'

describe AttrDependency do

  it "should be a method on classes" do
    Class.new.respond_to?(:attr_dependency).must_equal true
  end

  describe "basic dependency behavior" do

    class MyClass
      attr_dependency(:my_dependency) { Array }
    end

    describe "calling the factory method" do

      it "should fetch the default dependency" do
        obj = MyClass.new
        obj.my_dependency.must_equal Array
      end
    end

    describe "performing dependency injection" do

      before { MyClass.my_dependency { String } }

      it "should now return String" do
        obj = MyClass.new
        obj.my_dependency.must_equal String
      end
    end

  end

  describe "memoization" do

    class UuidDependency
      attr_dependency(:memo_dependency, memoize: true) { SecureRandom.uuid }
      attr_dependency(:uuid_dependency)                { SecureRandom.uuid }
    end

    subject { UuidDependency.new }

    it "should memoize the result" do
      subject.memo_dependency.must_equal subject.memo_dependency
      subject.uuid_dependency.wont_equal subject.uuid_dependency
    end

  end

  describe "passing in arguments" do

    class ClassWithStructDependency
      MyStruct = Struct.new(:foo, :bar)
      attr_dependency(:struct) { |f, b| MyStruct.new(f, b) }
    end

    subject { ClassWithStructDependency.new }

    it "should receive the arguments passed into the factory method" do
      result = subject.struct("baz", "quux")
      result.foo.must_equal "baz"
      result.bar.must_equal "quux"
    end

    describe "with varying numbers of arguments" do

      it "should allow too many arguments to be passed in" do
        result = subject.struct("baz", "quux", "boosh")
        result.foo.must_equal "baz"
        result.bar.must_equal "quux"
      end

      it "should allow too few arguments to be passed in" do
        result = subject.struct("baz")
        result.foo.must_equal "baz"
        result.bar.must_be_nil
      end

    end

  end

  describe :with_dependencies do

    before { MyClass.my_dependency { Array } }

    it "should temporarily inject dependencies" do
      MyClass.with_dependencies(my_dependency: ->() { Hash }) do
        MyClass.new.my_dependency.must_equal Hash
      end

      MyClass.new.my_dependency.must_equal Array
    end

    it "should work with constants" do
      MyClass.with_dependencies(my_dependency: Hash) do
        MyClass.new.my_dependency.must_equal Hash
      end

      MyClass.new.my_dependency.must_equal Array
    end

    it "should work with objects defined inside the block?" do
      inside = nil
      MyClass.with_dependencies(my_dependency: Hash) do
        inside = MyClass.new
      end

      inside.my_dependency.must_equal Hash
      MyClass.new.my_dependency.must_equal Array
    end

  end


end
