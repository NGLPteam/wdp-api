# frozen_string_literal: true

module Links
  class Maintain
    include Dry::Monads[:do, :result]
    include MonadicPersistence

    prepend TransactionalCall

    def call(entity)
      EntityLink.by_source_or_target(entity).find_each do |link|
        yield check link
      end

      Success nil
    end

    private

    # @param [EntityLink] link
    # @return [Dry::Monads::Result]
    def check(link)
      if link.valid?
        monadic_save link
      else
        link.destroy!

        Success nil
      end
    end
  end
end
