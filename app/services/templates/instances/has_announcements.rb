# frozen_string_literal: true

module Templates
  module Instances
    module HasAnnouncements
      extend ActiveSupport::Concern

      ENTITY_TUPLE = %i[entity_type entity_id].freeze

      included do
        has_many_readonly :announcements, primary_key: ENTITY_TUPLE, foreign_key: ENTITY_TUPLE

        delegate :show_announcements?, to: :template_definition
      end

      def force_show
        super || force_show_because_of_announcements?
      end

      def force_show_because_of_announcements?
        show_announcements? && has_announcements?
      end

      def has_announcements?
        announcements.exists?
      end

      def show_announcements?
        template_definition.try(:show_announcements?)
      end
    end
  end
end
