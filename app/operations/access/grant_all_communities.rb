# frozen_string_literal: true

module Access
  class GrantAllCommunities
    include MeruAPI::Deps[grant: "access.grant"]
    include Dry::Monads[:result, :do]

    # @param [AccessGrantSubject] subject
    def call(subject, role:)
      Community.find_each do |community|
        yield grant.call role, on: community, to: subject
      end
    end
  end
end
