# frozen_string_literal: true

# @see Harvesting::Options::List
# @see Harvesting::Options::Read
# @see Harvesting::Options::Format
# @see Harvesting::Options::Mapping
module HasHarvestingOptions
  extend ActiveSupport::Concern

  included do
    attribute :list_options, Harvesting::Options::List.to_type, default: proc { {} }
    attribute :read_options, Harvesting::Options::Read.to_type, default: proc { {} }
    attribute :format_options, Harvesting::Options::Format.to_type, default: proc { {} }
    attribute :mapping_options, Harvesting::Options::Mapping.to_type, default: proc { {} }

    delegate :use_metadata_mappings?, to: :mapping_options
  end

  # @param [HasHarvestingOptions] parent
  # @return [void]
  def inherit_harvesting_options_from!(parent)
    self.list_options = parent.list_options.as_json
    self.read_options = parent.read_options.as_json
    self.format_options = parent.format_options.as_json
    self.mapping_options = parent.mapping_options.as_json
  end

  # @param [Hash] read_options
  # @param [Hash] list_options
  # @param [Hash] format_options
  # @param [Hash] mapping_options
  # @return [void]
  def merge_harvesting_options!(read_options: {}, list_options: {}, format_options: {}, mapping_options: {}, **)
    self.list_options.merge! list_options
    self.read_options.merge! read_options
    self.format_options.merge! format_options
    self.mapping_options.merge! mapping_options
  end

  # @param [Harvesting::Attempts::Metadata] metadata
  # @return [void]
  def modify_attempt_metadata!(metadata)
    metadata.max_records = read_options.max_record_count
  end
end
