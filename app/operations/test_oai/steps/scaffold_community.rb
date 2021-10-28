# frozen_string_literal: true

module TestOAI
  module Steps
    class ScaffoldCommunity
      include Dry::Monads[:do, :result]
      include MonadicPersistence

      def call(title:)
        community = Community.where(title: title).first_or_initialize do |c|
          c.schema_version = SchemaVersion["default:community"]
        end

        monadic_save community
      end
    end
  end
end
