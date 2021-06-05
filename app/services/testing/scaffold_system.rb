# frozen_string_literal: true

module Testing
  class ScaffoldSystem
    extend Dry::Initializer

    option :community_count, AppTypes::Integer, default: proc { 10 }
    option :fake_user_count, AppTypes::Integer, default: proc { 500 }

    def call
      ApplicationRecord.logger.silence do
        scaffold_roles!

        scaffold_communities!

        scaffold_users_and_role_assignments!
      end
    end

    private

    def scaffold_roles!
      Testing::ScaffoldRoles.new.call
    end

    def scaffold_communities!
      return if Community.count >= community_count

      builder = Testing::ScaffoldCommunity.new

      community_count.times do
        builder.call
      end
    end

    def scaffold_users_and_role_assignments!
      return if User.testing.count >= fake_user_count

      FactoryBot.create_list(:user, fake_user_count)

      Testing::AssignRandomRoles.new.call
    end
  end
end
