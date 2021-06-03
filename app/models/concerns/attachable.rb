# frozen_string_literal: true

module Attachable
  extend ActiveSupport::Concern

  included do
    has_many :assets, class_name: "Asset", as: :attachable, dependent: :destroy

    # Will set a foreign key association, not directly used
    has_many :attached_assets, class_name: "Asset", dependent: :destroy
  end
end
