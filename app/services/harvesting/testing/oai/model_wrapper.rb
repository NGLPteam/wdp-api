# frozen_string_literal: true

module Harvesting
  module Testing
    module OAI
      class ModelWrapper < ::OAI::Provider::Model
        include Dry::Initializer[undefined: false].define -> do
          param :model, Harvesting::Testing::Types::OAIRecordKlass

          option :identifier_field, Harvesting::Testing::Types::Coercible::String, default: proc { model.primary_key || "identifier" }
          option :metadata_prefix, Harvesting::Types::String, default: proc { model.metadata_prefix || "jats" }
          option :timestamp_field, Harvesting::Testing::Types::Coercible::String, default: proc { "changed_at" }
          option :limit, Harvesting::Testing::Types::Limit, default: proc { Harvesting::Testing::Types::LIMIT_DEFAULT }
        end

        def earliest
          model.minimum(timestamp_field)
        end

        def latest
          model.maximum(timestamp_field)
        end

        # @param [Harvesting::Testing::OAI::SampleRecord] record
        def deleted?(record)
          record.deleted?
        end

        # @param [String, :all] selector
        # @param [Hash] options
        def find(selector, options = {})
          constraints = constraints_for(options)

          constraints.find(selector)
        end

        # @see Testing::SampleSet
        def sets
          @sets ||= ::Harvesting::Testing::OAI::Set.all
        end

        private

        # @param [Hash] options
        # @param [::OAI::Provider::ResumptionToken] token
        # @return [Harvesting::Testing::OAI::Constraints]
        def constraints_for(options = {})
          opts = options.symbolize_keys.merge(model:, identifier_field:, timestamp_field:, earliest:, latest:, limit:)

          # In case it wasn't in options for some reason, set the default metadata prefix for this wrapper.
          opts[:metadata_prefix] ||= metadata_prefix

          Harvesting::Testing::OAI::Constraints.new(**opts)
        end
      end
    end
  end
end
