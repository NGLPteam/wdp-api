# frozen_string_literal: true

class GraphqlPolicy
  ALLOW_ANONYMOUS = ->(*) { true }
  ALLOW_INTROSPECTION = ->(*) { true }

  HAS_GLOBAL_ADMIN_ACCESS = ->(obj, args = {}, ctx = {}) { ctx[:current_user]&.has_global_admin_access? }

  POLICY_CAN = ->(policy_klass, action) do
    ->(obj, args, ctx) { policy_klass.new(ctx[:current_user], obj.object).public_send(action) }
  end

  POLICY_SHOW = ->(policy_klass) { POLICY_CAN[policy_klass, :show?] }

  RULES = {
    Types::MutationType => {
      create_collection: HAS_GLOBAL_ADMIN_ACCESS
    },
    Types::QueryType => {
      viewer: ALLOW_ANONYMOUS,
    },
  }.with_indifferent_access

  class << self
    def guard(type, field)
      type.introspection? ? ALLOW_INTROSPECTION : RULES.dig(type, field)
    end
  end
end
