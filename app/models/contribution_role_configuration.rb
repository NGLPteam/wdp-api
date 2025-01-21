# frozen_string_literal: true

class ContributionRoleConfiguration < ApplicationRecord
  include HasEphemeralSystemSlug
  include TimestampScopes

  belongs_to :controlled_vocabulary, inverse_of: :contribution_role_configurations

  has_many :controlled_vocabulary_items, through: :controlled_vocabulary

  belongs_to :default_item, class_name: "ControlledVocabularyItem", inverse_of: :default_item_configurations
  belongs_to :other_item, class_name: "ControlledVocabularyItem", inverse_of: :other_item_configurations, optional: true
  belongs_to :source, polymorphic: true, inverse_of: :contribution_role_configuration

  validates :source_id, uniqueness: { scope: :source_type }

  before_validation :set_defaults!, on: :create

  # @return [void]
  def reset!
    self.controlled_vocabulary = ControlledVocabulary.system_default_contribution_roles

    self.default_item = controlled_vocabulary.controlled_vocabulary_items.first_tagged_with("default")

    self.other_item = controlled_vocabulary.controlled_vocabulary_items.first_tagged_with("other")
  end

  private

  # @return [void]
  def set_defaults!
    self.controlled_vocabulary ||= ControlledVocabulary.system_default_contribution_roles

    self.default_item ||= controlled_vocabulary.controlled_vocabulary_items.first_tagged_with("default")

    self.other_item ||= controlled_vocabulary.controlled_vocabulary_items.first_tagged_with("other")
  end
end
