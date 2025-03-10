# frozen_string_literal: true

module Support
  # StoreModel is missing a few nice things from ActiveModel,
  # like validation callbacks, and the ability to use brackets
  # to access attributes.
  module EnhancedStoreModel
    extend ActiveSupport::Concern

    included do
      include StoreModel::Model
      include ActiveModel::Validations::Callbacks
    end

    # @param [#to_s] attr
    # @return [Object]
    def [](attr)
      public_send(attr)
    end

    # @param [#to_s] attr
    # @param [Object]
    # @return [void]
    def []=(attr, value)
      public_send(:"#{attr}=", value)
    end

    # @param [{ Symbol => Object }] attrs
    # @return [void]
    def merge!(attrs)
      return unless attrs.kind_of?(Hash)

      attrs.each do |attr, value|
        self[attr] = value
      end
    end

    def to_hash
      as_json
    end

    module ClassMethods
      # @return [<Symbol>]
      def accessors
        attribute_names.flat_map { [_1.to_sym, :"#{_1}="] }
      end

      # A better method for generating enums that does not store numeric values.
      #
      # We want to store the actual strings.
      #
      # @param [Symbol] attr_name
      # @param [<#to_s>] values
      # @param [{ Symbol => Object }] options
      def actual_enum(attr_name, *values, suffix: nil, prefix: nil, default: nil, allow_blank: false, **options)
        values.flatten!

        mapped = values.index_with(&:to_s).symbolize_keys

        options[:in] = mapped
        options[:_suffix] = suffix if suffix
        options[:_prefix] = prefix if prefix
        options[:default] = default

        enum attr_name, **options

        prepend EnumNullifier.new(attr_name) if allow_blank
      end
    end

    # We need to allow enum fields to optionally be `nil`.
    #
    # @api private
    class EnumNullifier < Module
      def initialize(enum_name)
        @enum_name = enum_name

        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        def #{@enum_name}
          super.presence
        end
        RUBY
      end
    end
  end
end
