# frozen_string_literal: true

module DSL
  module WithDescription
    extend ActiveSupport::Concern

    def description(desc = nil)
      @description = desc if desc.present?
      @description
    end

    def description?
      description.present?
    end

    included do
      expose :description
    end
  end
end
