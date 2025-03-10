# frozen_string_literal: true

class AddHarvestProtocolEnum < ActiveRecord::Migration[7.0]
  def change
    create_enum :harvest_protocol, %w[unknown oai]

    create_enum :harvest_record_status, %w[pending active skipped deleted]
  end
end
