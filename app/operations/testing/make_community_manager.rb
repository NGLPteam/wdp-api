# frozen_string_literal: true

module Testing
  class MakeCommunityManager
    include Dry::Monads[:do, :result]
    include MeruAPI::Deps[grant_access: "access.grant"]
    include MonadicPersistence

    def call(user)
      user.global_access_control_list.communities = {
        manage_access: true,
        read: true,
        create: true,
        update: true,
        delete: true,
        assets: {
          read: true,
          create: true,
          update: true,
          delete: true
        }
      }

      yield monadic_save user

      manager = Role.fetch "Manager"

      Community.find_each do |community|
        yield grant_access.call manager, on: community, to: user
      end

      Success true
    end
  end
end
