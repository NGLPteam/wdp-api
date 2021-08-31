# frozen_string_literal: true

module Contributors
  class PersonProperties
    include StoreModel::Model

    attribute :given_name, :string
    attribute :family_name, :string
    attribute :title, :string
    attribute :affiliation, :string

    validates :given_name, :family_name, presence: true

    # @return [String]
    def display_name
      [given_name, family_name].map(&:presence).compact.join(" ").strip.presence
    end
  end
end
