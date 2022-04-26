# frozen_string_literal: true

module HasSystemSlug
  extend ActiveSupport::Concern

  included do
    before_validation :set_temporary_system_slug!, on: :create
    after_create :set_system_slug!

    validates :system_slug, presence: true
  end

  # @api private
  # @return [String]
  def system_slug_id
    id
  end

  private

  # @return [void]
  def set_system_slug!
    set_system_slug_with! system_slug_id

    update_column :system_slug, system_slug
  end

  # @param [String] slug_value
  # @return [void]
  def set_system_slug_with!(slug_value)
    slugged = WDPAPI::Container["slugs.encode_id"].call(slug_value).value!

    self.system_slug = slugged
  end

  # @return [void]
  def set_temporary_system_slug!
    return if persisted? || system_slug?

    set_system_slug_with! SecureRandom.uuid
  end

  class_methods do
    def fetch_by_slug(slug)
      where(system_slug: slug).first
    end
  end
end
