# frozen_string_literal: true

module Contributors
  class PersonProperties
    include StoreModel::Model
    include Digestable

    attribute :given_name, :string
    attribute :family_name, :string
    attribute :appellation, :string
    attribute :title, :string
    attribute :affiliation, :string
    attribute :parsed, People::PersonalName.to_type, default: proc { {} }

    validates :given_name, :family_name, presence: true

    def digest
      digest_with do |dig|
        dig << "given_name" << given_name.to_s
        dig << "family_name" << family_name.to_s
      end
    end

    def digestable?
      given_name.present? && family_name.present?
    end

    # @return [String]
    def display_name
      [given_name, family_name].map(&:presence).compact.join(" ").strip.presence
    end
  end
end
