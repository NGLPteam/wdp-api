# frozen_string_literal: true

module Templates
  # A digest of all {TemplateInstance} records, uninioned into a single table for introspection.
  #
  # The original tables are more optimized and are the source of truth.
  class InstanceDigest < ApplicationRecord
    include HasEphemeralSystemSlug
    include TimestampScopes

    belongs_to :template_instance, polymorphic: true, inverse_of: :instance_digest
    belongs_to :template_definition, polymorphic: true, inverse_of: :instance_digests
    belongs_to :layout_instance, polymorphic: true, inverse_of: :template_instance_digests
    belongs_to :layout_definition, polymorphic: true, inverse_of: :template_instance_digests
    belongs_to :entity, polymorphic: true, inverse_of: :template_instance_digests

    attribute :config, Templates::Digests::Instances::Config.to_type
    attribute :slots, Templates::Digests::Instances::Slots.to_type
  end
end
