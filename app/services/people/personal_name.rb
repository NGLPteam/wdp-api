# frozen_string_literal: true

module People
  # Equivalent to the result of `Namae::Name`
  #
  # @see Utility::ParseName
  class PersonalName
    include StoreModel::Model

    attribute :family, :string
    attribute :given, :string
    attribute :suffix, :string
    attribute :particle, :string
    attribute :dropping_particle, :string
    attribute :nick, :string
    attribute :appellation, :string
    attribute :title, :string
  end
end
