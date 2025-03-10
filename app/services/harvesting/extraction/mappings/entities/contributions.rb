# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Entities
        # Takes a template for capturing information about contributions
        # for a specific entity.
        class Contributions < Harvesting::Extraction::Mappings::Abstract
          include Dry::Effects::Handler.State(:capturing_contribution)
          include Dry::Effects::Handler.State(:contribution_index)

          attribute :contributions_template, ::Mappers::StrippedString

          render_attr! :contributions_template, :contribution_proxies, data: true do |result|
            Array(result.data["contributions"])
          end

          xml do
            root "contributions"

            map_content to: :contributions_template
          end

          around_render_contributions_template :capture_contributions!

          def empty?
            contributions_template.blank?
          end

          def environment_options
            super.merge(captures_contributions: true)
          end

          # @return [Dry::Monads::Result]
          def render_for(render_context)
            rendered_attributes_for(render_context) => { contributions_template: }

            contributions_template
          end

          private

          # @return [void]
          def capture_contributions!
            render_data[:contributions] = []

            with_contribution_index 0 do
              with_capturing_contribution false do
                yield
              end
            end

            render_data[:contributions].compact_blank!.uniq!
          end
        end
      end
    end
  end
end
