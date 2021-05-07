# frozen_string_literal: true

module Types
  module Sluggable
    include BaseInterface

    field :slug, Types::SlugType, null: false

    def slug
      object.id
    end
  end
end
