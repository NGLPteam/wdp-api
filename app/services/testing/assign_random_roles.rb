# frozen_string_literal: true

module Testing
  class AssignRandomRoles
    include MeruAPI::Deps[grant_access: "access.grant"]
    include Dry::Monads[:do, :result]
    prepend HushActiveRecord

    def call
      roles = [Role.fetch("manager"), Role.fetch("editor")]

      communities = Community.sample(5)
      collections = Collection.where.not(community: communities).sample(50)
      items = Item.where.not(collection: collections).sample(100)

      things = [*communities, *collections, *items].shuffle

      User.testing.find_each do |user|
        things.sample(20).each do |thing|
          role = roles.sample

          yield grant_access.call role, on: thing, to: user
        end
      end
    end
  end
end
