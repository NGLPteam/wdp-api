# frozen_string_literal: true

module Harvesting
  module Metadata
    module ValueExtraction
      # This defines a single discrete value that can be extracted from
      # a data source. It supports many candidates for retrieving it,
      # and can optionally be nil.
      class Value
        include Dry::Core::Equalizer.new(:full_path)
        include Dry::Effects.Resolve(:resolve_dependencies)
        include Dry::Effects::Handler.Resolve
        include Dry::Monads[:result]
        include Dry::Monads::Do.for(:call)
        include Dry::Initializer[undefined: false].define -> do
          param :identifier, Harvesting::Types::Identifier
          param :candidates, Harvesting::Metadata::ValueExtraction::Candidate::List.constrained(min_size: 1)

          option :dependencies, Harvesting::Types::Paths
          option :require_match, Harvesting::Types::Bool, default: proc { true }
          option :set_id, Harvesting::Types::Identifier.optional, default: proc {}
          option :type, Harvesting::Metadata::ValueExtraction::Types::Type, default: proc { Harvesting::Types::Any }
          option :default, Harvesting::Types::Any, default: proc {}

          option :full_path, Harvesting::Types::Path, default: proc { [set_id, identifier].compact.join(?.) }
        end

        include Harvesting::Metadata::ValueExtraction::GeneratesErrors
        include Shared::Typing

        error_context :value

        map_type! key: Harvesting::Types::Identifier
        map_type! key: Harvesting::Types::Path, on: :PathMap

        # @param [Harvesting::Metadata::ExtractsValues] source
        # @return [Dry::Monads::Result]
        def call(source)
          deps = yield resolve_dependencies!

          with_provisions(deps: deps) do
            resolve_candidates_with source
          end
        end

        # @return [Dry::Monads::Result]
        def default_value
          return Success(nil) if default.nil? && optional?

          type.try(default).to_monad.or do |reason|
            extraction_error!(:invalid_default, message: reason, path: full_path, default: default)
          end
        end

        # The complement of {#required?}
        def optional?
          !required?
        end

        # Whether a candidate *must* match for this value to be considered valid.
        def required?
          require_match.present?
        end

        # Defines this value on a struct subclass for the final return value of value
        # extraction.
        #
        # @api private
        # @param [Class] a subclass of {Harvesting::Metadata::ValueExtraction::Struct}
        # @return [void]
        def expose_on_struct!(klass)
          method_name = optional? ? :attribute? : :attribute

          attr_type = required? ? type : type.optional

          attr_type = attr_type.default(default) unless default.nil? || attr_type.default?

          klass.__send__ method_name, identifier, attr_type
        end

        private

        # Iterate over each candidate and try to retrieve a value.
        #
        # If no candidate matches, it will depend on if the value is {#required?}.
        def resolve_candidates_with(source)
          candidates.each do |candidate|
            result = candidate.call(source)

            return result if result.success?
          end

          return default_value if optional?

          extraction_error! :no_candidates_matched, path: full_path
        end

        # @return [Dry::Monads::Success(PropertyHash)]
        def resolve_dependencies!
          return Success(PropertyHash.new.freeze) if dependencies.blank?

          resolve_dependencies.call(dependencies).bind do |matched|
            Success PropertyHash.new(dependencies.zip(matched).to_h)
          end
        end

        # Set up resolvable values for dry-effects.
        #
        # @param [PropertyHash] deps
        # @return [void]
        def with_provisions(deps:)
          provisions = { dependencies: deps, value: self, value_id: identifier, value_type: type }

          provide provisions do
            yield
          end
        end
      end
    end
  end
end
