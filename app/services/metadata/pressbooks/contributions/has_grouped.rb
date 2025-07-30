# frozen_string_literal: true

module Metadata
  module Pressbooks
    module Contributions
      module HasGrouped
        extend ActiveSupport::Concern

        included do
          defines :grouped_contribution_mapping, type: Metadata::Types::GroupedContributionMapping

          grouped_contribution_mapping Dry::Core::Constants::EMPTY_HASH

          attribute :grouped_contributions, method: :derive_grouped_contributions
        end

        # @api private
        def derive_grouped_contributions
          self.class.grouped_contribution_mapping.each_with_object([]) do |(role, attr), groups|
            contributors = Array(__send__(attr))

            next if contributors.blank?

            grouped = ::Metadata::Pressbooks::Contributions::Grouped.new(role:, contributors:)

            groups << grouped
          end
        end

        module ClassMethods
          # @param [Symbol] attr
          # @param [#to_s] role
          # @return [void]
          def groups_contributions!(attr, role:)
            mapping = grouped_contribution_mapping.merge(role.to_s => attr)

            grouped_contribution_mapping mapping.freeze
          end
        end
      end
    end
  end
end
