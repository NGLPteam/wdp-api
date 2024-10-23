# frozen_string_literal: true

# A helper model for storing enumerated value "attributes" in i18n.
#
# For example, a "description" value keyed to each value in a pg enum.
module ScopedTranslatableAttributes
  extend ActiveSupport::Concern

  included do
    extend Dry::Core::ClassAttributes

    include Dry::Core::Memoizable

    defines :i18n_scoped_namespace,
      :i18n_default_key_attr,
      :i18n_key_attr,
      :i18n_scoped_values_attr,
      type: Support::Types::Coercible::String.optional

    defines :i18n_scoped_attributes,
      type: Support::Types::Coercible::Array.of(Support::Types::Coercible::Symbol)

    i18n_scoped_namespace nil

    i18n_default_key_attr nil

    i18n_key_attr nil

    i18n_scoped_values_attr nil

    i18n_scoped_attributes [].freeze

    memoize :i18n_default_key
    memoize :i18n_key
    memoize :i18n_scoped_values
  end

  def i18n_default_key
    self.class.i18n_default_key_attr.then { __send__(_1) if _1.present? }
  end

  def i18n_default_key?
    i18n_default_key.present?
  end

  def i18n_key
    self.class.i18n_key_attr.then { __send__(_1) if _1.present? }
  end

  def i18n_scoped_namespace
    self.class.i18n_scoped_namespace
  end

  def i18n_scoped_attributes
    self.class.i18n_scoped_attributes
  end

  def i18n_scoped_values
    self.class.i18n_scoped_values_attr.then { _1.present? ? Array(__send__(_1)) : [] }.freeze
  end

  # @param [#to_s] attr_name
  # @param [#to_s] value
  # @return [String, nil]
  def i18n_scoped_translatable_lookup(attr_name, value)
    base = :"#{i18n_key}.#{value}.#{attr_name}"

    default = [].tap do |defaults|
      defaults << :"default.#{i18n_default_key}.#{value}.description" if i18n_default_key.present?
      defaults << ""
    end

    scope = i18n_scoped_namespace.to_sym

    I18n.t(base, scope:, default:, raise: false)
  end

  module ClassMethods
    def configure_i18n_scoped_attributes!(namespace:, key_from:, values_from:, default_key_from: nil)
      i18n_scoped_namespace namespace
      i18n_default_key_attr default_key_from
      i18n_key_attr key_from
      i18n_scoped_values_attr values_from
    end

    # @param [#to_sym] attr_name
    # @return [void]
    def i18n_scoped_attribute!(attr_name)
      mod = ScopedTranslatableAttribute.new(attr_name:)

      include mod

      merged = i18n_scoped_attributes | [mod.attr_name]

      i18n_scoped_attributes merged.freeze
    end
  end

  class ScopedTranslatableAttribute < Module
    include Dry::Core::Equalizer.new(:attr_name)

    # @return [Symbol]
    attr_reader :attr_name

    # @return [Symbol]
    attr_reader :plural

    # @return [Symbol]
    attr_reader :single

    def initialize(attr_name:)
      super()

      @attr_name = attr_name.to_sym

      @single = attr_name.to_s.singularize.to_sym

      @plural = attr_name.to_s.pluralize.to_sym

      @accessor_method = :"scoped_#{single}_for"

      @all_values_method = :"i18n_scoped_#{plural}"

      define_methods!
    end

    private

    # @return [void]
    def define_methods!
      class_eval <<~RUBY, __FILE__, __LINE__ + 1
      def #{@accessor_method}(value)
        i18n_scoped_translatable_lookup(#{attr_name.inspect}, value)
      end

      def #{@all_values_method}
        i18n_scoped_values.index_with do |value|
          #{@accessor_method}(value)
        end.freeze
      end
      RUBY
    end
  end
end
