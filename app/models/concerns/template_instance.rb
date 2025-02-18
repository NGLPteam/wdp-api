# frozen_string_literal: true

module TemplateInstance
  extend ActiveSupport::Concern
  extend DefinesMonadicOperation

  include HasLayoutKind
  include HasTemplateKind
  include Renderable
  include Support::Caching::Usage

  included do
    attribute :config, Templates::Instances::Config.to_type

    belongs_to :entity, polymorphic: true

    has_one :instance_digest, as: :template_instance, class_name: "Templates::InstanceDigest", dependent: :destroy

    has_many_readonly :prev_siblings, -> { for_prev }, as: :template_instance, class_name: "Templates::InstanceSibling"
    has_many_readonly :next_siblings, -> { for_next }, as: :template_instance, class_name: "Templates::InstanceSibling"

    before_validation :infer_config!
  end

  # @!attribute [r] all_slots_empty
  # @see Templates::SlotMappings::AbstractInstanceSlots#all_empty?
  # @return [Boolean]
  def all_slots_empty
    slots.all_empty?
  end

  alias all_slots_empty? all_slots_empty

  # Boolean complement of {#force_show?}.
  #
  # Used in {#hidden} to bypass the hide logic.
  def allow_hide?
    !force_show?
  end

  # @see Templates::Instances::BuildConfig
  # @see Templates::Instances::ConfigBuilder
  monadic_operation! def build_config
    call_operation("templates.instances.build_config", self)
  end

  # @see Templates::Instances::BuildDigestAttributes
  # @see Templates::Instances::DigestAttributesBuilder
  monadic_operation! def build_digest_attributes
    call_operation("templates.instances.build_digest_attributes", self)
  end

  # @api private
  # @abstract
  # @return [Boolean]
  def force_show
    false
  end

  # @see #force_show
  def force_show?
    force_show
  end

  # For most templates, it is just derived from from {#hidden_by_empty_slots}.
  #
  # @abstract Provides the uncached value for {#hidden} and can be overridden in subclasses.
  # @api private
  # @see #hidden?
  # @return [Boolean]
  def calculate_hidden
    hidden_by_empty_slots?
  end

  # @!attribute [r] hidden
  # Whether or not the template should be hidden in the frontend, derived from {#calculate_hidden}.
  #
  # Because it can be expensive to calculate at runtime, and we need to expose
  # it on siblings, it uses {Support::Caching::Cache} to safely store the value across requests.
  # @return [Boolean]
  def hidden
    vog_cache cache_key, :hidden do
      allow_hide? && calculate_hidden
    end
  end

  alias hidden? hidden

  # @!attribute [r] hidden_by_empty_slots
  # @return [Boolean]
  def hidden_by_empty_slots
    slots.hides_template?
  end

  alias hidden_by_empty_slots? hidden_by_empty_slots

  # @see Templates::Digests::Instances::TemplateUpserter
  monadic_operation! def upsert_instance_digests
    call_operation("templates.digests.instances.upsert_for_template", self)
  end

  private

  # @return [void]
  def infer_config!
    self.config = build_config!
  end

  module ClassMethods; end
end
