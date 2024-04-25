# frozen_string_literal: true

module Harvesting
  module Metadata
    module ValueExtraction
      # @api private
      class Values
        include Dry::Container::Mixin
        include Dry::Effects.Resolve(:value_id)
        include Dry::Monads[:result, :list, :validated]
        include Harvesting::Metadata::ValueExtraction::GeneratesErrors

        error_context :values_registry

        alias paths keys

        # A wrapper around the normal dry-container register method
        # that ensures our value is a result monad.
        def register!(path, value)
          register path, MonadHelpers.to_result(value)
        end

        alias register_value! register!

        # @param [String] parent
        # @return [Dry::Monads::Result]
        # @return [Harvesting::Metadata::Error]
        def resolve_dependency(parent)
          resolve_result(parent).or do |reason|
            extraction_error!(
              :failed_dependency,
              message: "Failed to resolve #{parent.inspect}",
              parent:,
              for: (value_id { nil }),
              reason:,
            )
          end
        end

        # @param [<String>] paths
        # @return [Dry::Monads::Result]
        def resolve_dependencies(*paths)
          paths.flatten!

          deps = paths.map do |path|
            resolve_dependency(path).to_validated
          end

          List::Validated.coerce(deps).traverse.to_result.fmap(&:to_a)
        end

        # @param [String] path
        # @return [Dry::Monads::Result]
        def resolve_result(path)
          resolve(path).to_monad.to_result
        rescue Dry::Container::Error
          extraction_error!(
            :unknown_path,
            message: "No value registered for #{path.inspect}",
            path:
          )
        end

        # Called in order to finalize this values mapping.
        #
        # It will make sure that each registered value was
        # successful and transform the entire mapping into
        # a hash that allows us to feed it into a generated
        # {Harvesting::Metadata::ValueExtraction::Struct}.
        #
        # @api private
        # @return [Dry::Monads::Success(Hash)]
        # @return [Dry::Monads::Failure]
        def to_monad
          validations = paths.map do |path|
            result = resolve_result(path)

            result.either(
              ->(value) { Success[path, value] },
              ->(reason) { Failure[path, reason] }
            ).to_validated
          end

          List::Validated.coerce(validations).traverse.to_result.either(
            ->(tuples) do
              # We use property hash to automatically generate
              # a nested hash from full-paths
              phash = PropertyHash.new tuples.to_a.to_h

              Success phash.to_h
            end,
            ->(tuples) do
              values = tuples.to_a.to_h

              value_paths = values.keys.sort

              extraction_error!(
                :invalid_values,
                values:,
                paths: value_paths,
              )
            end
          )
        end
      end
    end
  end
end
