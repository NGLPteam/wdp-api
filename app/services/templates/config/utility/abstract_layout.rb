# frozen_string_literal: true

module Templates
  module Config
    module Utility
      # @abstract
      class AbstractLayout < Shale::Mapper
        extend DefinesMonadicOperation
        extend Dry::Core::ClassAttributes

        include Dry::Core::Constants
        include Dry::Core::Memoizable
        include Mappers::BetterXMLPrinting

        # @see Templates::Config::ApplyLayout
        # @see Templates::Config::LayoutApplicator
        # @return [Dry::Monads::Success(LayoutDefinition)]
        monadic_operation! def apply_to(schema_version, **options)
          MeruAPI::Container["templates.config.apply_layout"].(self, schema_version, **options)
        end

        class << self
          def build_default
            templates = attributes.fetch(:templates).type.build_default

            new.tap do |layout|
              layout.templates = templates
            end
          end

          def inherited(klass)
            klass.include ::Templates::Config::ConfiguresLayout

            super
          end
        end
      end
    end
  end
end
