# frozen_string_literal: true

module Harvesting
  module Testing
    module OAI
      # @abstract
      class SampleProvider < ::OAI::Provider::Base
        extend Dry::Core::ClassAttributes

        defines :provider_definition, type: ::Harvesting::Testing::Types.Instance(::Harvesting::Testing::ProviderDefinition).optional

        provider_definition nil

        # @!attribute [r] rack_app
        # @return [Harvesting:Testing::OAI::RackWrapper]
        def rack_app
          @rack_app ||= RackWrapper.new(self)
        end

        class << self
          # @param [Harvesting::Types::MetadataFormatName] metadata_format_name
          # @return [void]
          def declare!(metadata_format_name)
            definition = Harvesting::Testing::ProviderDefinition.oai.find_by!(metadata_format_name:)

            provider_definition definition

            provider_definition.set_up_oai! self
          end
        end
      end
    end
  end
end
