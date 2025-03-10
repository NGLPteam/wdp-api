# frozen_string_literal: true

FactoryBot.define do
  factory :harvest_record do
    association :harvest_source, :jats

    sample_record { harvest_source.available_sample_record }

    metadata_format { sample_record.try(:metadata_format_name) || harvest_source.metadata_format || "jats" }

    sequence(:identifier) do |n|
      sample_record.try(:full_identifier) || "record-#{n}"
    end

    status do
      if sample_record.try(:deleted)
        "deleted"
      else
        "active"
      end
    end

    raw_metadata_source do
      sample_record.try(:metadata_source) || "<record />"
    end
  end
end
