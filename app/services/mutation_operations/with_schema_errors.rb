# frozen_string_literal: true

module MutationOperations
  module WithSchemaErrors
    extend ActiveSupport::Concern

    included do
      before_prepare :prepare_schema_errors!
    end

    def with_applied_schema_values!(application)
      with_result! application do |m|
        m.success do |applied_entity|
          yield applied_entity
        end

        m.failure(:invalid_values) do |_, result|
          add_schema_errors! result
        end

        m.failure do |*reasons|
          # :nocov:
          Failure[*reasons]
          # :nocov:
        end
      end
    end

    # @param [Dry::Validation::Result] result
    # @return [void]
    def add_schema_errors!(result)
      result.errors.each do |error|
        path = error.path.join(?.).presence

        if path.blank? || /\Abase\z/.match?(path)
          add_global_error! error.text
        else
          graphql_response[:schema_errors] << to_schema_error(error)
        end
      end
    end

    # @api private
    # @param [Dry::Schema::Message, Dry::Schema::Hint, Dry::Validation::Message] error
    # @return [{ Symbol => Object }]
    def to_schema_error(error)
      {}.tap do |h|
        h[:hint] = error.hint?
        h[:path] = error.path.join(?.)
        h[:base] = false
        h[:message] = error.text
        h[:metadata] = error.meta
      end
    end

    # @return [void]
    def prepare_schema_errors!
      graphql_response[:schema_errors] = []
    end
  end
end
