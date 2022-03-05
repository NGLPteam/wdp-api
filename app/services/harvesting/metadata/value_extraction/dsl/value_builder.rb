# frozen_string_literal: true

module Harvesting
  module Metadata
    module ValueExtraction
      module DSL
        class ValueBuilder
          Type = Harvesting::Metadata::ValueExtraction::Types::Type

          # @!attribute [r] builder
          # @return [Harvesting::Metadata::ValueExtraction::DSL::Builder]
          include Dry::Effects.Resolve(:builder)

          # @!attribute [r] set
          # @return [Harvesting::Metadata::ValueExtraction::DSL::SetBuilder]
          include Dry::Effects.Resolve(:set)

          include Dry::Effects::Handler.Resolve
          include Dry::Initializer[undefined: false].define -> do
            param :identifier, Harvesting::Types::Identifier

            option :require_match, Harvesting::Types::Bool, default: proc { true }
            option :type, Type, default: proc { Harvesting::Types::Any }
          end

          def initialize(*)
            super

            @candidates = []
            @dependencies = ::Set.new
            @options = {
              dependencies: @dependencies,
              require_match: require_match,
              set_id: set_identifier,
              type: type
            }
          end

          # Build a value with a fluent DSL.
          #
          # @return [Harvesting::Metadata::ValueExtraction::Value]
          def build(&block)
            provide({ value: self }, overridable: true) do
              instance_eval(&block)
            end

            Harvesting::Metadata::ValueExtraction::Value.new(
              identifier,
              @candidates,
              @options
            )
          end

          # @!group DSL Methods

          # @return [void]
          def allow_no_matches!
            @options[:require_match] = false
          end

          # @return [void]
          def candidate(**options, &block)
            candidates = Harvesting::Metadata::ValueExtraction::DSL::CandidateBuilder.new(**options).build(&block)

            @candidates += candidates
          end

          # @param [<String, Symbol>] deps
          # @return [void]
          def depends_on(*deps)
            deps.flatten!

            full_deps = Harvesting::Types::Paths[deps].map do |dep|
              normalize_dependency dep
            end

            @dependencies.merge full_deps
          end

          def extracts_values!
            type! :extracted_values
          end

          # @return [void]
          def require_match!
            @options[:require_match] = true
          end

          def type!(type)
            @options[:type] = Type[type]
          end

          def attribute(*names, **options, &block)
            candidate(**options) do
              attribute(*names)

              instance_eval(&block) if block_given?
            end
          end

          # Set up XPath candidates with an optional block.
          #
          # @param [<String>] queries
          def xpath(*queries, **options, &block)
            candidate(**options) do
              xpath(*queries)

              instance_eval(&block) if block_given?
            end
          end

          # Set up an array of XPath candidates with an optional block.
          #
          # @param [<String>] queries
          def xpath_list(*queries, **options, &block)
            candidate(**options) do
              xpath_list(*queries)

              instance_eval(&block) if block_given?
            end
          end

          def from_value(path, **options, &block)
            candidate(**options) do
              from_value(path)

              instance_eval(&block) if block_given?
            end
          end

          # @!endgroup

          private

          # @param [String] dependency
          # @return [String]
          def normalize_dependency(dependency)
            case dependency
            when Harvesting::Types::Identifier
              # Return the id if we have already defined it
              # as a top-level value
              return dependency if builder.has_value?(dependency)

              # Infer that it belongs to the same set otherwise
              [set_identifier, dependency].compact.join(?.)
            else
              dependency
            end
          end

          def set_identifier
            resolved = set { nil }

            resolved&.identifier
          end
        end
      end
    end
  end
end
