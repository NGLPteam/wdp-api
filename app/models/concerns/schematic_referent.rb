# frozen_string_literal: true

# A concern for models that can be the referent in a schema property,
# a.k.a. the thing being referred to.
module SchematicReferent
  extend ActiveSupport::Concern

  included do
    has_many :incoming_schematic_scalar_references, as: :referent, dependent: :destroy, class_name: "SchematicScalarReference"
    has_many :incoming_schematic_collected_references, as: :referent, dependent: :destroy, class_name: "SchematicCollectedReference"

    scope :with_collected_referent, -> { where(id: unscoped.joins(:incoming_schematic_collected_references).select(arel_table[:id])) }
    scope :with_scalar_referent, -> { where(id: unscoped.joins(:incoming_schematic_scalar_references).select(arel_table[:id])) }

    scope :with_referent, -> { where(id: unscoped.with_collected_referent.or(unscoped.with_scalar_referent)) }
  end

  # @return [{ Symbol => Object }]
  def to_schematic_referent_option
    {
      label: to_schematic_referent_label,
      value: to_schematic_referent_value
    }.merge(to_schematic_referent_extra)
  end

  # @abstract
  # @return [String]
  def to_schematic_referent_label
    raise NotImplementedError, "Must implement #{self.class}##{__method__}"
  end

  # @return [String]
  def to_schematic_referent_value
    to_encoded_id
  end

  # @abstract
  # @return [Hash]
  def to_schematic_referent_extra
    {}.tap do |h|
      h[:kind] = kind if respond_to?(:kind)
    end
  end
end
