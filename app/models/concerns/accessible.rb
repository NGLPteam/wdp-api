# frozen_string_literal: true

module Accessible
  extend ActiveSupport::Concern

  included do
    has_many :access_grants, as: :accessible, dependent: :destroy
  end
end
