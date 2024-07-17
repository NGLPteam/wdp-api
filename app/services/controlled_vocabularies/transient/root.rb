# frozen_string_literal: true

module ControlledVocabularies
  module Transient
    class Root < Support::FlexibleStruct
      include Support::Typing

      attribute :namespace, Types::Namespace
      attribute :identifier, Types::Identifier
      attribute :version, Types::Version
      attribute :name, Types::Name
      attribute :provides, Types::Provides
      attribute :items, Types::Array.of(ControlledVocabularies::Transient::Item).constrained(min_size: 1)

      attribute? :description, Types::Description

      def finding
        { namespace:, identifier:, version: version.to_s, }
      end

      def to_update
        { name:, description:, provides:, }
      end
    end
  end
end
