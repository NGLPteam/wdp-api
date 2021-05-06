# frozen_string_literal: true

module Shared
  module Functions
    extend Dry::Transformer::Registry

    import Dry::Transformer::HashTransformations

    class << self
      def to_hash(value)
        Hash(value.to_h)
      end

      def add_jti(hsh)
        hsh[:jti] = SecureRandom.uuid

        hsh
      end

      # @param [String] token
      # @return [Hash]
      def decode_token(token)
        WDPAPI::Container["tokens.decode"].call(token).value!
      end

      # @return [String]
      def encode_token(hsh)
        WDPAPI::Container["tokens.encode"].call(hsh).value!
      end

      def find_model(hsh, key, model: key.to_s.classify.constantize)
        id = hsh.delete key

        hsh[key] = model.find id if id.present?

        hsh
      end

      def find_models(hsh, keys = [], **keys_and_models)
        keys.map do |key|
          [key.to_sym, key.to_s.classify.constantize]
        end.to_h.merge(keys_and_models).reduce(hsh) do |h, (key, model)|
          find_model(h, key, model: model)
        end
      end

      def to_model_id(hsh, key)
        hsh[key] = hsh.delete(key)&.id

        return hsh
      end

      def to_model_ids(hsh, keys)
        Array(keys).reduce(hsh) do |h, key|
          to_model_id(h, key)
        end
      end

      def to_numeric_time(hsh, key)
        hsh[key] = AppTypes::Time[hsh[key]]&.to_i

        return hsh
      end

      def from_numeric_time(hsh, key)
        hsh[key] = Time.zone.at(hsh[key]) if hsh[key].present?
      rescue TypeError
        hsh
      else
        hsh
      end
    end
  end
end
