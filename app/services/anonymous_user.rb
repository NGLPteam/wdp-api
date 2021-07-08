# frozen_string_literal: true

ANONYMOUS_ALLOWED_ACTIONS = [].freeze

AnonymousUser = Naught.build do |config|
  config.mimic User

  config.predicates_return false

  def allowed_actions
    ANONYMOUS_ALLOWED_ACTIONS
  end

  def anonymous?
    true
  end

  def authenticated?
    false
  end

  def has_global_admin_access?
    false
  end

  def present?
    true
  end
end
