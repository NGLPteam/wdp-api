# frozen_string_literal: true

module Communities
  # Grant built-in system roles for a single {Community}.
  class GrantSystemRoles
    include Dry::Monads[:result, :do]
    include WDPAPI::Deps[
      grant_access: "access.grant",
    ]

    # @param [Community] community
    # @return [Dry::Monads::Result]
    def call(community)
      yield add_admins_to! community

      Success(nil)
    end

    private

    # @param [Community] community
    # @return [Dry::Monads::Result]
    def add_admins_to!(community)
      admin = Role.fetch :admin

      User.global_admins.find_each do |user|
        yield grant_access.call(admin, to: user, on: community)
      end

      Success nil
    end
  end
end
