# frozen_string_literal: true

module ControlledVocabularies
  module Persistence
    class RootPersistor < Support::HookBased::Actor
      include MonadicPersistence

      include Dry::Initializer[undefined: false].define -> do
        param :root, ControlledVocabularies::Transient::Root::Type
      end

      standard_execution!

      # @return [ControlledVocabulary]
      attr_reader :controlled_vocabulary

      # @return [Dry::Monads::Success(ControlledVocabulary)]
      def call
        run_callbacks :execute do
          yield prepare!

          yield persist!
        end

        Success controlled_vocabulary
      end

      wrapped_hook! def prepare
        @controlled_vocabulary = ControlledVocabulary.where(root.finding).first_or_initialize

        super
      end

      wrapped_hook! def persist
        controlled_vocabulary.assign_attributes root.to_update

        yield monadic_save controlled_vocabulary

        super
      end
    end
  end
end
