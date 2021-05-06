# frozen_string_literal: true

AnonymousUser = Naught.build do |config|
  config.mimic User

  config.predicates_return false

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
