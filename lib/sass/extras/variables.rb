module Sass
  module Extras
    module Variables
      def self.included(base)
        base.declare :variable_get, [:name]
        base.declare :global_variable_get, [:name]
      end

      # Get the value of a variable with the given name, if it exists in the
      # current scope or in the global scope.
      #
      # @example
      #   $a-false-value: false;
      #   variable-get(a-false-value) => false
      #
      #   variable-get(nonexistent) => null
      #
      # @overload variable_get($name)
      #   @param $name [Sass::Script::Value::String] The name of the variable to
      #     check. The name should not include the `$`.
      # @return [Sass::Script::Value::Bool] Whether the variable is defined in
      #   the current scope.
      def variable_get(name)
        assert_type name, :String, :name
        environment.caller.var(name.value)
      end

      # Check whether a variable with the given name exists in the global
      # scope (at the top level of the file).
      #
      # @example
      #   $a-false-value: false;
      #   global-variable-get(a-false-value) => false
      #
      #   .foo {
      #     $some-var: false;
      #     global-variable-get(some-var) => null
      #   }
      #
      # @overload global_variable_get($name)
      #   @param $name [Sass::Script::Value::String] The name of the variable to
      #     check. The name should not include the `$`.
      # @return [Sass::Script::Value::Bool] Whether the variable is defined in
      #   the global scope.
      def global_variable_get(name)
        assert_type name, :String, :name
        environment.global_env.var(name.value)
      end
    end
  end
end
