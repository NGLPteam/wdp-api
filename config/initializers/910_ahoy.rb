# frozen_string_literal: true

require "ahoy"

module Ahoy
  class Store < Ahoy::DatabaseStore
    HAS_ENTITY = ->(subject) do
      subject.respond_to?(:entity) && subject.entity.kind_of?(HierarchicalEntity)
    end

    # Set up ahoy events with additional metadata
    # @param [Hash] data
    def track_event(data)
      data[:context] = parse_analytics_context

      entity = data[:properties].try(:delete, :entity)

      set_entity! data, entity

      subject = data[:properties].try(:delete, :subject)

      set_subject! data, subject

      super
    end

    private

    # @return ["admin", "frontend"]
    def parse_analytics_context
      case request.headers["X-Analytics-Context"]
      when "admin" then "admin"
      else
        "frontend"
      end
    end

    # @param [Hash] data
    # @param [HierarchicalEntity, nil] entity
    # @return [void]
    def set_entity!(data, entity)
      return if data[:entity_id].present? || entity.blank? || !entity.kind_of?(HierarchicalEntity)

      data[:entity_type] = entity.model_name.to_s
      data[:entity_id] = entity.id
    end

    # @param [Hash] data
    # @param [ApplicationRecord] subject
    # @return [void]
    def set_subject!(data, subject)
      return unless subject.present? && subject.kind_of?(ApplicationRecord) && subject.persisted?

      data[:subject_type] = subject.model_name.to_s
      data[:subject_id] = subject.id

      case subject
      when ::Asset
        set_entity! data, subject.attachable
      when HAS_ENTITY
        set_entity! data, subject.entity
      end
    end
  end
end

module Patches
  module BetterAhoyGeocoding
    # @param [String] visit_token
    # @param [String] ip
    # @return [void]
    def perform(visit_token, ip)
      MeruAPI::Container["analytics.update_geocoding"].(visit_token, ip)
    end
  end
end

Rails.application.config.to_prepare do
  Ahoy::GeocodeV2Job.prepend Patches::BetterAhoyGeocoding
end

Ahoy.api = true
Ahoy.api_only = true

# set to true for geocoding (and add the geocoder gem to your Gemfile)
# we recommend configuring local geocoding as well
# see https://github.com/ankane/ahoy#geocoding
#
# We currently disable this in the test environment because
# we're not going to provide a local DB for github actions
Ahoy.geocode = !Rails.env.test?

Ahoy.job_queue = :ahoy

# Ahoy.cookie_domain = :all

# Ahoy.cookie_options = { same_site: :lax }

Ahoy.cookies = false

Ahoy.mask_ips = true

Ahoy.track_bots = Rails.env.development? || Rails.env.test?
