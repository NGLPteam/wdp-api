# frozen_string_literal: true

module Contributions
  class Metadata
    include StoreModel::Model

    attribute :corresp, :boolean, default: proc { false }
    attribute :title, :string, default: nil
    attribute :affiliation, :string, default: nil
    attribute :display_name, :string, default: nil
    attribute :location, :string, default: nil

    def fetch(attribute, &block)
      attributes[attribute.to_s].presence || yield
    end
  end
end
