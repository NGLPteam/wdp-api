# frozen_string_literal: true

module InlineRendering
  extend ActiveSupport::Concern

  include EntityTemplating

  def has_invalid_layouts?
    layout_invalidations.exists?
  end

  def has_missing_layouts?
    main_layout_instance.blank?
  end

  # @return [HierarchicalEntity]
  def validated_layout_source
    if has_invalid_layouts?
      invalidation = layout_invalidations.latest

      invalidation.process!

      reload
    elsif has_missing_layouts?
      render_layouts!

      reload
    end

    return self
  end
end
