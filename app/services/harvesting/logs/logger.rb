# frozen_string_literal: true

module Harvesting
  module Logs
    class Logger
      HARVEST_MODELS = %i[
        harvest_source
        harvest_attempt
        harvest_mapping
        harvest_record
        harvest_entity
      ].freeze

      HARVEST_MODEL_IDS = HARVEST_MODELS.map { :"#{_1}_id" }.freeze

      HARVEST_MODELS.each do |model_name|
        include Dry::Effects::Handler.Reader(model_name)
        include Dry::Effects.Reader(model_name, default: nil)

        delegate :id, to: model_name, prefix: true, allow_nil: true
      end

      LEVELS = %i[
        fatal
        error
        warn
        info
        debug
        trace
      ].freeze

      # @return [void]
      def log(message, tags: [], level: :debug, **metadata)
        tuple = build_model_tuple.merge(level:, at: Time.current, tags: Array(tags.map(&:to_s)), message:, metadata:)

        HarvestMessage.insert(tuple, returning: false, unique_by: false)

        return
      end

      LEVELS.each do |level|
        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        def #{level}(message, **kwargs)
          kwargs[:level] = #{level.to_sym.inspect}

          log(message, **kwargs)
        end
        RUBY
      end

      private

      def build_model_tuple
        HARVEST_MODEL_IDS.index_with { __send__(_1) }
      end
    end
  end
end
