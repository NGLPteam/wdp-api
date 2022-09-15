# frozen_string_literal: true

module Analytics
  class EventResolver < AbstractResolver
    include Analytics::FiltersByDateRange
    include Analytics::FunnelsByDatePrecision

    option :name, Analytics::Types::EventName

    option :entities, Analytics::Types::Entities, default: proc { [] }

    option :subjects, Analytics::Types::Subjects, default: proc { [] }

    before_build :filter_by_event_name!

    before_build :filter_by_entities!

    before_build :filter_by_subjects!

    def filter_by_event_name!
      augment_scope! do |scope|
        scope.where(name: name)
      end
    end

    # @return [void]
    def filter_by_entities!
      augment_scope! do |scope|
        scope.where(entity: entities) if entities.present?
      end
    end

    # @return [void]
    def filter_by_subjects!
      augment_scope! do |scope|
        scope.where(subject: subjects) if subjects.present?
      end
    end

    def initialize_scope
      super.frontend
    end
  end
end
