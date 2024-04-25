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

    class_methods do
      # A better method for generating enums that does not store numeric values.
      #
      # We want to store the actual strings.
      #
      # @param [Symbol] attr_name
      # @param [<#to_s>] values
      # @param [{ Symbol => Object }] options
      def actual_enum(attr_name, *values, **options)
        values.flatten!

        mapped = values.index_with(&:to_s)

        options[:in] = mapped

        enum attr_name, **options
      end
    end
  end
end
