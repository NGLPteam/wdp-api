# frozen_string_literal: true

module Entities
  class UnknownProperty < Entities::Error
    # @return [String, nil]
    attr_reader :group_name

    # @return [String]
    attr_reader :property_name

    # @return [String]
    attr_reader :property_path

    # @return [String]
    attr_reader :available_property_paths

    message_keys! :property_path

    message_format! <<~MSG
    [%<declaration>s] does not have property: %<property_path>s
    MSG

    did_you_mean_with! :property_path, :available_property_paths

    # @param [#to_s] property_path
    def initialize(property_name:, entity:, group_name: nil, **options)
      @group_name = group_name

      @property_name = property_name

      @property_path = [group_name, property_name].compact_blank.join(?.)

      @available_property_paths = entity.schema_version.property_paths

      super
    end
  end
end
