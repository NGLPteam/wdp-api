# frozen_string_literal: true

FactoryBot.define do
  factory :harvest_source do
    system_slug { "" }
    name { "" }
    description { "MyText" }
    kind { "" }
    source_format { "" }
    list_options { "" }
    read_options { "" }
    format_options { "" }
    mapping_options { "" }
  end
end
