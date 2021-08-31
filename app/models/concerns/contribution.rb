# frozen_string_literal: true

module Contribution
  extend ActiveSupport::Concern

  included do
    attribute :metadata, Contributions::Metadata.to_type, default: proc { {} }

    alias_attribute :role, :kind

    delegate :kind, to: :contributor, prefix: true
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
end
