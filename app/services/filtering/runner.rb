# frozen_string_literal: true

module Filtering
  class Runner
    include Dry::Monads[:result]
    include Dry::Initializer[undefined: false].define -> do
      param :klass, Support::Models::Types::ModelClass

      option :base_scope, Support::Types::Relation, default: proc { klass.all }
      option :options, Types::Hash.map(Types::Coercible::Symbol, Types::Any)
      option :filter_klass, Types::FiltersClass, default: proc { "::Filtering::Scopes::#{klass.model_name.to_s.pluralize}".constantize }
    end

    # @return [Filtering::FilterScope]
    attr_reader :filters

    def call
      @filters = filter_klass.new(**options)

      result = filters.apply_to base_scope

      Success result
    end
  end
end
