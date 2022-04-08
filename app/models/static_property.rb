# frozen_string_literal: true

# A list of static properties that can be ordered by on {OrderingEntryCandidate} or a related model.
class StaticProperty < FrozenRecord::Base
  include ActiveModel::Validations
  include Dry::Core::Memoizable
  include FrozenArel
  include FrozenSchema
  include TranslatedFrozenRecord

  SEARCH_STRATEGIES = %w[named_variable_date property text].freeze
  SEARCH_OPERATORS = %w[date_equals date_gte date_lte equals matches in_any numeric_gte numeric_lte].freeze

  schema! do
    required(:path).filled(:string)
    optional(:searchable).value(:bool)
    optional(:search_strategy).filled(:string, included_in?: SEARCH_STRATEGIES)
    optional(:search_operators).array(:string) do
      filled? > included_in?(SEARCH_OPERATORS)
    end
    required(:type).filled(:string, included_in?: EntitySearchableProperty::SUPPORTED_PROPERTY_TYPES)
  end

  scope :searchable, -> { where(searchable: true) }

  self.primary_key = "path"

  add_index :path, unique: true

  has_translated! :label
  has_translated! :description

  memoize def identifier
    path.tr(?., ?_)
  end

  # @return [String]
  memoize def property_table_path
    "$#{path}$"
  end

  # @return [String]
  def default_label
    path.titleize
  end

  private

  def primary_key_for_i18n
    path
  end

  class << self
    # @return [<Searching::CoreProperty>]
    def searchable_core_properties
      searchable.map do |prop|
        ::Searching::CoreProperty.new path: prop.path, static_property: prop
      end
    end
  end
end
