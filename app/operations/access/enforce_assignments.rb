# frozen_string_literal: true

module Access
  # Ensure that all admin {User users} have an {AccessGrant} on each {Community},
  # as well as auditing any users who have lost admin privileges to remove said
  # role.
  #
  # @see PendingRoleAssignment
  # @see Access::EnforceAssignmentsJob
  class EnforceAssignments
    include Dry::Monads[:result, :do]
    include MeruAPI::Deps[
      grant: "access.grant",
      revoke: "access.revoke",
      synchronize_all_access_info: "users.synchronize_all_access_info",
      synchronize_access_info: "users.synchronize_access_info",
    ]

    # @param [AccessGrantSubject, nil] subject
    # @return [Dry::Monads::Result]
    def call(subject: nil)
      assigned = yield assign_pending!(subject:)

      invalid = yield revoke_invalid!(subject:)

      access_info = yield check_access_info!(subject:)

      Success(assigned:, access_info:, invalid:)
    end

    private

    # @param [AccessGrantSubject, nil] subject
    # @return [Dry::Monads::Success(Integer)]
    def assign_pending!(subject: nil, **)
      count = 0

      PendingRoleAssignment.to_assign.for_possible_subject(subject).find_each do |assignment|
        yield grant.call(assignment.role, **assignment.to_grant_options)

        count += 1
      end

      Success count
    end

    # @param [AccessGrantSubject, nil] subject
    # @return [Dry::Monads::Success(Integer)]
    def check_access_info!(subject: nil, **)
      count = 0

      case subject
      in ::User
        yield synchronize_access_info.(subject)

        count += 1
      else
        count += yield synchronize_all_access_info.()
      end

      Success count
    end

    # @param [{ Symbol => Object }] options
    # @return [Dry::Monads::Success(Integer)]
    def revoke_invalid!(**options)
      count = 0

      count += yield revoke_in!(AccessGrant.invalid_admin_assignments, **options)

      Success count
    end

    # @param [ActiveRecord::Relation<AccessGrant>] scope
    # @param [AccessGrantSubject, nil] subject
    # @return [Dry::Monads::Result]
    def revoke_in!(scope, subject: nil, **)
      count = 0

      scope = scope.for_possible_subject(subject)

      scope.find_each do |grant|
        grant.destroy!

        count += 1
      end

      Success count
    end
  end
end
