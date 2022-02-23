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
    include WDPAPI::Deps[
      grant: "access.grant",
      revoke: "access.revoke",
    ]

    # @param [AccessGrantSubject, nil] subject
    # @return [Dry::Monads::Result]
    def call(subject: nil)
      assigned = yield assign_pending!(subject: subject)

      invalid = yield revoke_invalid!(subject: subject)

      Success(assigned: assigned, invalid: invalid)
    end

    private

    # @param [AccessGrantSubject, nil] subject
    # @return [Dry::Monads::Result]
    def assign_pending!(subject: nil, **)
      count = 0

      PendingRoleAssignment.to_assign.for_possible_subject(subject).find_each do |assignment|
        yield grant.call(*assignment.to_grant)

        count += 1
      end

      Success count
    end

    # @param [{ Symbol => Object }] options
    # @return [Dry::Monads::Result]
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
