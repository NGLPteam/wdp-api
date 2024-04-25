# frozen_string_literal: true

class PilotCommunity < FrozenRecord::Base
  include FrozenArel
  include FrozenSchema

  add_index :unique_identifier, unique: true
  add_index :seed_identifier
  add_index :identifier

  scope :for_seed, ->(name) { where(seed_identifier: name.to_s) }

  schema! PilotHarvesting::CommunityDefinition do
    required(:unique_identifier).filled(:string)
    required(:seed_identifier).filled(:string)
  end

  def matches?(only)
    only.blank? || identifier.in?(only)
  end

  class << self
    def assign_defaults!(record)
      record["unique_identifier"] = record.values_at("seed_identifier", "identifier").join(?-)

      super
    end

    # @param [String, Symbol] name
    # @return [Hash]
    def grouped_for(name, only_communities: [])
      only_communities = Array(only_communities)

      communities = for_seed(name).select do |community|
        community.matches?(only_communities)
      end.map(&:as_json)

      { communities: }
    end

    # @param [String, Symbol] name
    # @return [PilotHarvesting::Root]
    def root_for(name, only_communities: [])
      definition = grouped_for(name, only_communities:)

      ::PilotHarvesting::Root.new(definition)
    end
  end
end
