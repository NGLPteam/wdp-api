# frozen_string_literal: true

module ControlledVocabularies
  module Transient
    class Item < Support::FlexibleStruct
      include Support::Typing

      attribute :identifier, Types::Identifier
      attribute :label, Types::Label

      attribute? :children, Types::Array.of(self).default { [] }
      attribute? :description, Types::Description
      attribute? :unselectable, Types::Bool.default(false)
      attribute? :url, Types::URL

      def finding
        { identifier:, }
      end

      def to_update
        { label:, description:, unselectable:, url:, }
      end
    end
  end
end
