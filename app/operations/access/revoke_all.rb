# frozen_string_literal: true

module Access
  class RevokeAll
    include Dry::Monads[:result, :do]

    # @param [AccessGrantSubject] subject
    # @return [Dry::Monads::Result]
    def call(subject)
      destroyed_count = AccessGrant.for_user(subject).destroy_all.size

      Success destroyed_count
    end
  end
end
