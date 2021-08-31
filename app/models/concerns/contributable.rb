# frozen_string_literal: true

module Contributable
  extend ActiveSupport::Concern

  included do
    delegate :contributions_klass, to: :class
  end

  # @return [(Class, Hash, (:contributor_id, Symbol))]
  def for_upsert_contribution_mutation(contributor: nil)
    foreign_key = :"#{model_name.singular}_id"

    attributes = {}
    attributes[:contributor_id] = contributor.id if contributor.present?
    attributes[foreign_key] = id

    [contributions_klass, attributes, %I[contributor_id #{foreign_key}]]
  end

  module ClassMethods
    def contributions_klass
      @contributions_klass ||= reflect_on_association(:contributions).klass
    end
  end
end
