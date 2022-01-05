# frozen_string_literal: true

module Utility
  # Given a `Hash`, this service will deeply transform its keys into their decamelized forms.
  #
  # It respects the original type of key, so symbol keys will remain symbols,
  # while non-stringish keys will be ignored entirely.
  class HashDecamelizer
    extend Dry::Core::Cache

    include Dry::Initializer[undefined: false].define -> do
      param :value, Dry::Types["strict.hash"]
    end

    include WDPAPI::Deps[:inflector]

    # @return [Hash]
    def call
      value.deep_transform_keys do |key|
        case key
        when Symbol
          fetch_or_store key do
            inflector.underscore(key).to_sym
          end
        when String
          fetch_or_store key do
            inflector.underscore(key)
          end
        else
          key
        end
      end
    end
  end
end
