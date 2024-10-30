# frozen_string_literal: true

module Templates
  module Config
    module Utility
      # @abstract
      class AbstractTemplateSlots < Shale::Mapper
        extend Dry::Core::ClassAttributes

        include Dry::Core::Constants
        include Dry::Core::Memoizable

        # @see Templates::Slots::Definitions::Abstract
        # @return [{ Symbol => { :raw_template => String }}]
        def to_template_definition_slots
          template_record.slot_names.index_with do |raw_template|
            { raw_template: __send__(raw_template), }
          end.symbolize_keys
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
