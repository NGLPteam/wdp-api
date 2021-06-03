# frozen_string_literal: true

module Testing
  class AssignRandomRoles
    include WDPAPI::Deps[grant_access: "access.grant"]
    include Dry::Monads[:do, :result]

    def call
      roles = [Role.fetch("manager"), Role.fetch("editor")]

      communities = Community.sample(2)
      collections = Collection.where.not(community: communities).sample(20)
      items = Item.where.not(collection: collections).sample(20)

      things = [*communities, *collections, *items].shuffle

      User.testing.find_each do |user|
        role = roles.sample

        things.sample(20).each do |thing|
          yield grant_access.call role, on: thing, to: user
        end
      end
    end
  end
end
