# frozen_string_literal: true

# Shared logic for rendering an {Entity} or a {HierarchicalEntity} as a select option.
module EntityReferent
  extend ActiveSupport::Concern

  include SchematicReferent

  def to_schematic_referent_label
    title
  end

  def to_schematic_referent_kind
    hierarchical_type
  end

  # @abstract
  # @return [Hash]
  def to_schematic_referent_extra
    {}.tap do |h|
      h[:kind] = to_schematic_referent_kind
    end
  end
end
