# frozen_string_literal: true

# Instance methods for {AnonymousUser}.
module AnonymousInterface
  extend ActiveSupport::Concern

  include GlobalID::Identification

  # @note For anonymous users, this is always an empty array.
  # @see User#allowed_actions
  # @return [<String>]
  def allowed_actions
    []
  end

  # @note Always true for an {AnonymousUser}.
  # @see User#anonymous?
  def anonymous?
    true
  end

  alias anonymous anonymous?

  # @see User#authenticated?
  def authenticated?
    false
  end

  # @!attribute [r] created_at
  # @note An anonymous user's created time is always at the time of the request.
  # @return [ActiveSupport::TimeWithZone]
  def created_at
    Time.current
  end

  # @!attribute [r] email_verified
  # An anonymous user's email is never verified.
  # @return [false]
  def email_verified
    false
  end

  # @see User#has_global_admin_access?
  def has_global_admin_access?
    false
  end

  # @see User#has_any_upload_access?
  def has_any_upload_access?
    false
  end

  # @!attribute [r] id
  # A static ID to allow {AnonymousUser} to be encoded as a GlobalID.
  # @return ["ANONYMOUS"]
  def id
    "ANONYMOUS"
  end

  # @!attribute [r] name
  # @see User#name
  # @return [String]
  def name
    "Anonymous User"
  end

  # {AnonymousUser Anonymous users} are non-blank for purposes of object presence.
  #
  # @note Because of Naught's treatment of predicates, this would return `false`
  #   unless subsequently overridden.
  def present?
    true
  end

  # @see IdentitiesController#show
  # @return [Hash]
  def to_whoami
    {
      anonymous: true
    }
  end

  # @!attribute [r] updated_at
  # @note An anonymous user's last updated time is always at the time of the request.
  # @return [ActiveSupport::TimeWithZone]
  def updated_at
    Time.current
  end

  # Class methods for {AnonymousUser}.
  module ClassMethods
    # A simulation of `ApplicationRecord.find` to allow {AnonymousUser} to be decoded from a GlobalID.
    #
    # In effect, `AnonymousUser.find any_id` is equivalent to calling `AnonymousUser.new`.
    #
    # @return [AnonymousUser]
    def find(*)
      new
    end
  end
end
