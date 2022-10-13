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

  class << self
    def assign_defaults!(record)
      record["unique_identifier"] = record.values_at("seed_identifier", "identifier").join(?-)

      super
    end

    # @param [String, Symbol] name
    # @return [Hash]
    def grouped_for(name)
      communities = for_seed(name).map(&:as_json)

      { communities: communities }
    end

    # @param [String, Symbol] name
    # @return [PilotHarvesting::Root]
    def root_for(name)
      definition = grouped_for name

      ::PilotHarvesting::Root.new(definition)
    end
  end
end
