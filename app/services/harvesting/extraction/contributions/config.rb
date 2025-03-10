# frozen_string_literal: true

module Harvesting
  module Extraction
    module Contributions
      class Config < Support::FlexibleStruct
        include Dry::Core::Constants

        attribute? :vocabulary_identifier, Harvesting::Types::String.optional
        attribute? :default_identifier, Harvesting::Types::String.optional
        attribute? :external_role_mappers, Harvesting::Types::Array.of(Harvesting::Extraction::Contributions::ExternalRoleMapper).default(EMPTY_ARRAY)

        # @return [ControlledVocabulary]
        attr_reader :controlled_vocabulary

        # @return [ControlledVocabularyItem, nil]
        attr_reader :default_role

        # @return [ContributionRoleConfiguration]
        attr_reader :system_configuration

        # @return [Boolean]
        attr_reader :uses_system_configuration

        alias uses_system_configuration? uses_system_configuration

        def initialize(...)
          super

          @role_cache = Concurrent::Map.new

          @controlled_vocabulary = ControlledVocabulary.find_by(identifier: vocabulary_identifier)

          @uses_system_configuration = controlled_vocabulary.blank?

          maybe_load_system_configuration!

          load_default_role!
        end

        # @param [#to_s] raw_role
        # @return [ControlledVocabularyItem, nil]
        def role_for(raw_role)
          return default_role if raw_role.blank?

          role_name = raw_role.to_s.strip

          found_role = @role_cache.compute_if_absent role_name do
            role_identifier = role_identifier_for role_name

            controlled_vocabulary.item_for role_identifier
          end

          found_role || default_role
        end

        private

        # @return [void]
        def load_default_role!
          candidates = Enumerator.new do |y|
            y << controlled_vocabulary.item_for(default_identifier) if default_identifier.present?
            y << system_configuration.default_item if uses_system_configuration?
            y << controlled_vocabulary.first_tagged_with("default")
          end.lazy

          @default_role = candidates.detect(&:present?)
        end

        # @return [void]
        def maybe_load_system_configuration!
          return unless uses_system_configuration?

          @system_configuration = GlobalConfiguration.fetch.contribution_role_configuration

          @controlled_vocabulary = @system_configuration.controlled_vocabulary
        end

        # @param [String] role_name
        # @return [String]
        def role_identifier_for(role_name)
          external = external_role_mappers.detect { _1.match? role_name }

          external&.to || role_name
        end
      end
    end
  end
end
