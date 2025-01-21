# frozen_string_literal: true

module ControlledVocabularies
  module Transient
    class Item < Support::FlexibleStruct
      include Dry::Core::Constants
      include Support::Typing

      attribute :identifier, Types::Identifier
      attribute :label, Types::Label

      attribute? :children, Types::Array.of(self).default(EMPTY_ARRAY)
      attribute? :description, Types::Description
      attribute? :unselectable, Types::Bool.default(false)
      attribute? :priority, Types::Priority
      attribute? :tags, Types::Tags
      attribute? :url, Types::URL

      def finding
        { identifier:, }
      end

      def to_update
        { label:, description:, priority:, tags:, unselectable:, url:, }
      end
    end
  end
end
