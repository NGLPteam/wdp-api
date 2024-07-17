# frozen_string_literal: true

module ControlledVocabularies
  module Persistence
    class Persistor < Support::HookBased::Actor
      include Dry::Effects::Handler.Reader(:controlled_vocabulary)
      include Dry::Effects::Handler.State(:item_identifiers)
      include Dry::Effects::Handler.State(:parent)
      include Dry::Effects::Handler.State(:position)

      include Dry::Initializer[undefined: false].define -> do
        param :root, ControlledVocabularies::Transient::Root::Type
      end

      include MeruAPI::Deps[
        persist_root: "controlled_vocabularies.persistence.persist_root",
        persist_item: "controlled_vocabularies.persistence.persist_item",
      ]

      standard_execution!

      # @return [ControlledVocabulary]
      attr_reader :controlled_vocabulary

      # @return [Set<String>]
      attr_reader :item_identifiers

      # @return [Array, nil]
      attr_reader :item_set

      # @return [Integer]
      attr_reader :items_count

      # @return [ControlledVocabularyItem, nil]
      attr_reader :parent

      # @return [Integer]
      attr_reader :position

      # @return [Dry::Monads::Success(ControlledVocabulary)]
      def call
        run_callbacks :execute do
          yield prepare!

          yield upsert_root!

          yield upsert_items!

          yield clean_up!
        end

        Success controlled_vocabulary
      end

      wrapped_hook! def prepare
        @controlled_vocabulary = nil
        @item_identifiers = Set.new
        @item_set = nil
        @items_count = 0

        super
      end

      wrapped_hook! def upsert_root
        @controlled_vocabulary = yield persist_root.(root)

        super
      end

      wrapped_hook! def upsert_items
        root.items.each do |item|
          yield persist_item.(item)
        end

        @items_count = item_identifiers.size
        @item_identifiers = item_identifiers.to_a
        @item_set = controlled_vocabulary.calculate_item_set!

        super
      end

      wrapped_hook! def clean_up
        controlled_vocabulary.controlled_vocabulary_items.where.not(identifier: item_identifiers).destroy_all

        controlled_vocabulary.update_columns(item_identifiers:, item_set:, items_count:)

        ControlledVocabularySource.populate!

        super
      end

      around_upsert_items :provide_controlled_vocabulary!
      around_upsert_items :provide_item_identifiers!

      private

      # @return [void]
      def provide_controlled_vocabulary!
        with_controlled_vocabulary controlled_vocabulary do
          yield
        end
      end

      # @return [void]
      def provide_item_identifiers!
        with_item_identifiers(item_identifiers) do
          yield
        end
      end
    end
  end
end
