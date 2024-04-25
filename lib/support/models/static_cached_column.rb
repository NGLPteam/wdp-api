# frozen_string_literal: true

# @see Support::ColumnCache
class StaticCachedColumn < Support::FrozenRecordHelpers::AbstractRecord
  schema! do
    required(:id).filled(:string)
    required(:model_name).filled(:string)
    required(:table_name).filled(:string)
    required(:name).filled(:string)
    required(:type).filled(:string)
    required(:null).value(:bool)
    required(:sql_type_metadata).value(:hash)
    required(:default).maybe(:string)
    required(:default_function).maybe(:string)
    required(:has_default).value(:bool)
    required(:virtual).value(:bool)
  end

  self.primary_key = :id

  add_index :model_name

  class << self
    # @param [String] model
    # @param [String] name
    # @return [StaticCachedColumn, nil]
    def lookup(model, name)
      id = "#{model}##{name}"

      find(id)
    rescue FrozenRecord::RecordNotFound, Errno::ENOENT
      false
    end

    # @param [String] model
    # @param [String] name
    def has_column?(model, name)
      lookup(model, name).present?
    end

    # @param [Boolean] include_all whether to include non-ApplicationRecord models
    # @return [<Class(ActiveRecord::Base)>]
    def model_klasses(include_all: false)
      pluck(:model_name).uniq.each_with_object([]) do |name, klasses|
        klass = name.constantize

        next if !(klass < ::ApplicationRecord) && !include_all

        klasses << klass
      end
    end

    # @param [String] model
    # @param [String] name
    # @return [String]
    def type_for(model, name)
      lookup(model, name)&.type
    end
  end
end
