# frozen_string_literal: true

class SchematicScalarReference < ApplicationRecord
  include SchematicReference

  validates :path, presence: true, uniqueness: { scope: :referrer }
end
