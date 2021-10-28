# frozen_string_literal: true

module Contributors
  class Properties
    include StoreModel::Model
    include Digestable

    attribute :organization, Contributors::OrganizationProperties.to_type
    attribute :person, Contributors::PersonProperties.to_type

    delegate :organization?, :person?, to: :parent, allow_nil: true

    validates :organization, store_model: true, if: :organization?
    validates :person, store_model: true, if: :person?

    # @return [String, nil]
    def display_name
      case parent&.kind
      when "organization" then organization&.display_name
      when "person" then person&.display_name
      else
        if person.present?
          person.display_name
        elsif organization.present?
          organization.display_name
        end
      end.to_s
    end

    def digest
      digest_with do |dig|
        dig << "display_name" << display_name
      end
    end

    def digestable?
      display_name.present?
    end
  end
end
