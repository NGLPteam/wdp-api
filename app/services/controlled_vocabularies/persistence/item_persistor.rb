# frozen_string_literal: true

module ControlledVocabularies
  module Persistence
    class ItemPersistor < Support::HookBased::Actor
      include Dry::Effects.Reader(:controlled_vocabulary)
      include Dry::Effects.State(:item_identifiers) { Set.new }
      include MonadicPersistence

      include Dry::Initializer[undefined: false].define -> do
        param :item, ControlledVocabularies::Transient::Item::Type

        option :parent, Types::Item.optional, optional: true

        option :position, Types::Integer, default: proc { item_identifiers.size }
      end

      standard_execution!

      # @return [ControlledVocabularyItem]
      attr_reader :controlled_vocabulary_item

      # @return [Dry::Monads::Success(ControlledVocabulary)]
      def call
        run_callbacks :execute do
          yield prepare!

          yield persist!

          yield persist_children!
        end

        Success controlled_vocabulary_item
      end

      wrapped_hook! def prepare
        @controlled_vocabulary_item = controlled_vocabulary.controlled_vocabulary_items.where(item.finding).first_or_initialize

        super
      end

      wrapped_hook! def persist
        @controlled_vocabulary_item.assign_attributes(item.to_update)

        @controlled_vocabulary_item.assign_attributes(parent:, position:)

        @controlled_vocabulary_item.skip_rerank = true

        yield monadic_save controlled_vocabulary_item

        item_identifiers << item.identifier

        super
      end

      wrapped_hook! def persist_children
        item.children.each do |subitem|
          yield MeruAPI::Container["controlled_vocabularies.persistence.persist_item"].(subitem, parent: controlled_vocabulary_item)
        end

        super
      end
    end
  end
end
