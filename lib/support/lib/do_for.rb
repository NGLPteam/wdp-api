# frozen_string_literal: true

module Support
  # A module that gives you a `do_for!` decorator
  module DoFor
    # @param [Symbol] name
    # @return [Symbol]
    def do_for!(name)
      include Dry::Monads::Do.for name

      # If this is being called as a decorator, the method is already defined and dry-monad's
      # method watcher won't fire. We trigger it manually.
      if method_defined?(name) || protected_method_defined?(name) || private_method_defined?(name)
        __send__(:method_added, name)
      end

      return name
    end
  end
end
