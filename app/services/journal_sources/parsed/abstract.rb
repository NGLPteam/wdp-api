# frozen_string_literal: true

module JournalSources
  module Parsed
    # @abstract
    class Abstract < ::Support::FlexibleStruct
      include ActiveModel::Validations
      include Dry::Core::Constants
      include Dry::Monads[:maybe]
      include Dry::Matcher.for(:matched, with: ::JournalSources::Matcher)
      include JournalSources::Types

      extend Dry::Core::ClassAttributes

      UNKNOWN = JournalSources::Types::UNKNOWN

      defines :mode, type: Types::Mode

      mode :unknown

      attribute? :input, Types::KnowableString

      attribute? :volume, Types::KnowableString
      attribute? :issue, Types::KnowableString

      attribute? :journal, Types::OptionalString

      attribute? :year, Types::OptionalInteger
      attribute? :fpage, Types::OptionalInteger
      attribute? :lpage, Types::OptionalInteger

      validates :volume, presence: true, comparison: { other_than: UNKNOWN }, if: :has_expected_volume?

      validates :issue, presence: true, comparison: { other_than: UNKNOWN }, if: :has_expected_issue?

      # @return [JournalSources::Drop]
      def to_liquid
        JournalSources::Drop.new(self)
      end

      # @return [Dry::Monads::Some(JournalSources::Parsed::Abstract), Dry::Monads::None]
      def to_monad
        valid? ? Some(self) : None()
      end

      # @!group Mode Logic

      def full?
        mode == :full
      end

      def known?
        !unknown? && valid?
      end

      def mode
        self.class.mode
      end

      def has_expected_volume?
        full? || volume_only?
      end

      def has_expected_issue?
        full?
      end

      def unknown?
        mode == :unknown || invalid?
      end

      def volume_only?
        mode == :volume_only
      end

      # @!endgroup
    end
  end
end
