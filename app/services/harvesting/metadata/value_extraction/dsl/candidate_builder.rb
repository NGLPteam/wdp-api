# frozen_string_literal: true

module Harvesting
  module Metadata
    module ValueExtraction
      module DSL
        # Despite the name, this can actually build multiple candidates at once,
        # with different accessors to try with different pipelines.
        class CandidateBuilder
          Type = Harvesting::Metadata::ValueExtraction::Types::Type

          # @!attribute [r] set
          # @return [Harvesting::Metadata::ValueExtraction::DSL::SetBuilder, nil]
          include Dry::Effects.Resolve(:set)

          # @!attribute [r] value
          # @return [Harvesting::Metadata::ValueExtraction::DSL::ValueBuilder]
          include Dry::Effects.Resolve(:value)

          include Dry::Effects::Handler.Resolve
          include Dry::Initializer[undefined: false].define -> do
            option :type, Type.optional, default: proc {}
          end

          delegate :identifier, to: :value, prefix: true

          def initialize(...)
            super

            @accessors = []
            @pipelines = []

            @shared_options = {
              subtype: type,
              set_id: set_identifier,
              value_id: value_identifier,
            }
          end

          # @return [<Harvesting::Metadata::ValueExtraction::Candidate>]
          def build(&)
            provide(candidate: self) do
              instance_eval(&)
            end

            raise "must provide at least one accessor" if @accessors.none?

            @pipelines.push(Harvesting::Types::Identity) if @pipelines.blank?

            @accessors.product(@pipelines).map do |(accessor, pipeline)|
              Harvesting::Metadata::ValueExtraction::Candidate.new(
                accessor, pipeline,
                **@shared_options
              )
            end
          end

          # @!group DSL Methods

          # @param [<#to_sym>] attribute_names
          def attribute(*attribute_names)
            attribute_names.flatten!

            attribute_names.each do |name|
              add_accessor! :attribute, name
            end
          end

          def from_value(path)
            depends_on path

            add_accessor! :value, path
          end

          # @param [<String>] queries
          # @return [void]
          def xpath(*queries)
            queries.flatten!

            queries.each do |query|
              add_accessor! :xpath, query
            end
          end

          # @param [<String>] queries
          # @return [void]
          def xpath_list(*queries)
            queries.flatten!

            queries.each do |query|
              add_accessor! :xpath_list, query
            end
          end

          # @see Harvesting::Metadata::ValueExtraction::DSL::ValueBuilder#depends_on
          # @param [<String, Symbol>] deps
          # @return [void]
          def depends_on(*deps)
            value.depends_on(*deps)
          end

          def pipeline!(&)
            pipe = Harvesting::Metadata::ValueExtraction::Pipeline.make!(&)

            @pipelines.push pipe
          end

          def parse_journal_source!
            pipeline! do
              call_operation "harvesting.utility.parse_journal_source"
            end
          end

          # If set, this will use implication (`>>`) to compose the value's type.
          #
          # Useful for candidates that should only be permitted if they meet
          # certain criteria.
          #
          # @param [Dry::Types::Type] new_subtype
          # @return [void]
          def subtype!(new_subtype)
            @options[:subtype] = Type[new_subtype]
          end

          # @!endgroup

          private

          def set_identifier
            resolved = set { nil }

            resolved&.identifier
          end

          # @param [#to_s] name
          # @return [Class]
          def accessor_klass_for(name)
            return name if name.kind_of?(Class)

            klass_name = name.to_s.camelize(:upper)

            "::Harvesting::Metadata::ValueExtraction::Accessors::#{klass_name}".constantize
          end

          # @param [#to_s, Class] name
          # @param [<Object>] args
          # @param [{ Symbol => Object }] options
          # @return [void]
          def add_accessor!(name, *args, **options)
            klass = accessor_klass_for name

            accessor = klass.new(*args, **options)

            @accessors.push accessor
          end
        end
      end
    end
  end
end
