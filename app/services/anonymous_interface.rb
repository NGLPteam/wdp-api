# frozen_string_literal: true

module AnonymousInterface
  extend ActiveSupport::Concern

  include GlobalID::Identification

  ALLOWED_ACTIONS = [].freeze

  def allowed_actions
    []
  end

  def anonymous?
    true
  end

  alias anonymous anonymous?

  def authenticated?
    false
  end

  def created_at
    Time.current
  end

  def email_verified
    false
  end

  def has_global_admin_access?
    false
  end

  def id
    "ANONYMOUS"
  end

  def present?
    true
  end

  def updated_at
    Time.current
  end

  module ClassMethods
    def find(*)
      new
    end
  end
end
