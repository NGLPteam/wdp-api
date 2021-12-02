# frozen_string_literal: true

module Contribution
  extend ActiveSupport::Concern

  include HasEphemeralSystemSlug

  included do
    attribute :metadata, Contributions::Metadata.to_type, default: proc { {} }

    alias_attribute :role, :kind

    delegate :target_association, :target_association_name, :target_klass, to: :class

    delegate :kind, to: :contributor, prefix: true

    after_save :reload_contributor!

    after_destroy :recount_contributor_contributions!
  end

  def display_name
    overridable_contributor_attribute :display_name
  end

  def affiliation
    overridable_contributor_attribute :affiliation, kind: :person
  end

  def title
    overridable_contributor_attribute :title, kind: :person
  end

  def location
    overridable_contributor_attribute :location, kind: :organization
  end

  private

  def overridable_contributor_attribute(attribute_name, kind: nil)
    self.metadata ||= {}

    metadata.fetch attribute_name do
      contributor.fetch_property(attribute_name, from: kind)
    end
  end

  # @return [void]
  def recount_contributor_contributions!
    return if destroyed_by_association&.foreign_key == "contributor_id"

    case model_name.to_s
    when /\ACollection/
      contributor.count_collection_contributions!
    when /\AItem/
      contributor.count_item_contributions!
    end
  end

  # @return [void]
  def reload_contributor!
    recount_contributor_contributions!

    return unless association(:contributor).loaded?

    contributor.reload
  end

  module ClassMethods
    # @param ["asc", "desc"] direction
    # @return [ActiveRecord::Relation<Contribution>]
    def with_ordered_target_title(direction: "asc")
      case AppTypes::SimpleSortDirection[direction]
      when "desc"
        joins(target_association_name).merge(target_klass.order(title: :desc))
      else
        joins(target_association_name).merge(target_klass.order(title: :asc))
      end
    end

    # @api private
    # @return [ActiveRecord::Reflection::BelongsToReflection]
    def target_association
      @target_association ||= find_target_association
    end

    # @api private
    # @return [Symbol]
    def target_association_name
      target_association.name
    end

    # @api private
    # @return [Class]
    def target_klass
      target_association.klass
    end

    private

    # @return [ActiveRecord::Reflection::BelongsToReflection]
    def find_target_association
      case model_name.to_s
      when /\ACollection/
        reflect_on_association(:collection)
      when /\AItem/
        reflect_on_association(:item)
      else
        # :nocov:
        raise "Cannot derive target association for #{model_name}"
        # :nocov:
      end
    end
  end
end
