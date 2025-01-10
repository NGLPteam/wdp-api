# frozen_string_literal: true

module Templates
  module Config
    module Utility
      # @abstract
      class AbstractTemplateSlots < Shale::Mapper
        extend Dry::Core::ClassAttributes

        include Dry::Core::Constants
        include Dry::Core::Memoizable

        ALWAYS_HIDE_OVERRIDES = {
          blurb: {
            body: true
          },
        }.with_indifferent_access.freeze

        # @see Templates::Slots::Definitions::Abstract
        # @return [{ Symbol => Hash }]
        def to_template_definition_slots
          template_record.slot_names.index_with do |raw_template|
            overrides = build_overrides_for raw_template

            Hash(__send__(raw_template).try(:to_hash)).merge(overrides)
          end.deep_symbolize_keys
        end

        private

        def build_overrides_for(raw_template)
          hide_when_empty = ALWAYS_HIDE_OVERRIDES.dig(template_record.template_kind, raw_template)

          { hide_when_empty:, }.compact_blank
        end

        class << self
          def inherited(klass)
            klass.include ::Templates::Config::ConfiguresTemplate

            super
          end
        end
      end
    end
  end
end
