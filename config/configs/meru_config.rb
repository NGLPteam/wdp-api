# frozen_string_literal: true

class MeruConfig < ApplicationConfig
  attr_config tenant_id: "meru", tenant_name: "Meru", serialize_rendering: false

  coerce_types serialize_rendering: :boolean
end
