# frozen_string_literal: true

module Users
  class UpsertFromToken
    include Dry::Monads[:result, :do]
    include WDPAPI::Deps[
      enforce_role_assignments: "access.enforce_assignments",
      transform_token: "users.transform_token",
    ]

    RETURNING_EXPR = <<~SQL.squish
    "id",
    'global_admin' = ANY(roles) AS global_admin,
    (xmax = 0) AS inserted
    SQL

    UNIQUE_BY = %w[keycloak_id].freeze

    UPSERT_OPTS = {
      returning: Arel.sql(RETURNING_EXPR).freeze,
      unique_by: UNIQUE_BY
    }.freeze

    # @param [KeycloakRack::DecodedToken] token
    # @return [Dry::Monads::Result]
    def call(token)
      attributes = transform_token.call(token)

      was_admin = ::User.global_admins.exists?(keycloak_id: attributes[:keycloak_id])

      results = ::User.upsert attributes, UPSERT_OPTS

      result = results.first.to_h.with_indifferent_access

      admin_changed = result[:global_admin] ^ was_admin

      inserted = result[:inserted]

      user = User.find result[:id]

      if admin_changed || inserted
        yield enforce_role_assignments.call(subject: user)

        user.reload
        user.save!
      end

      Success user
    end
  end
end
