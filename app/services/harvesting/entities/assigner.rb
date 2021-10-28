# frozen_string_literal: true

module Harvesting
  module Entities
    class Assigner
      include Dry::Monads::Do.for(:realize)

      def initialize
        @metadata_kind = nil
        @attributes = {}.with_indifferent_access
        @props = ::PropertyHash.new
        @assets = {}
        @scalar_assets = {}
        @collected_assets = {}
        @schema_version = nil
      end

      # @param [String] name the name of the attribute to assign
      # @param [Object] value the value for the attribute
      # @return [self]
      def attribute!(name, value)
        @attributes[name] = realize(value).value!

        return self
      end

      alias attr! attribute!

      # @param [String] full_path The full path for the schema property. Supports dot notation.
      # @param [Object] value the value for the schema property
      # @return [self]
      def property!(full_path, value)
        @props[full_path] = realize(value).value!

        return self
      end

      alias prop! property!

      # @param [String] value
      # @return [self]
      def metadata_kind!(value)
        @metadata_kind = realize(value).value!

        return self
      end

      alias genre! metadata_kind!
      alias kind! metadata_kind!

      def schema_version!(version_or_string)
        return self if version_or_string.blank?

        @schema_version = SchemaVersion[version_or_string]

        return self
      end

      alias schema! schema_version!

      # @return [self]
      def unassociated_asset!(identifier, url, **props)
        @assets[identifier] = to_asset_source(identifier, url, props)

        return self
      end

      # @return [self]
      def scalar_asset!(full_path, identifier, url, **props)
        @scalar_assets[full_path] = to_asset_source(identifier, url, props)

        return self
      end

      # @return [self]
      def collected_asset!(full_path, identifier, url, **props)
        @collected_assets[full_path] ||= []

        @collected_assets[full_path].push(to_asset_source(identifier, url, props))

        return self
      end

      def to_attributes
        {
          metadata_kind: @metadata_kind,
          extracted_attributes: compile_attributes,
          extracted_properties: compile_properties,
          extracted_assets: compile_assets,
        }.tap do |h|
          h[:schema_version] = @schema_version if @schema_version.present?
        end
      end

      # @api private
      # @param [Object, Dry::Monads::Result] result
      # @return [Dry::Monads::Result]
      def realize(value)
        realized = value.respond_to?(:to_monad) ? yield(value) : value

        Dry::Monads.Success realized
      end

      private

      def compile_attributes
        @attributes.to_h.deep_stringify_keys
      end

      def compile_properties
        @props.to_h
      end

      def compile_assets
        scalar = @scalar_assets.each_with_object([]) do |(full_path, asset), ary|
          ref = { full_path: full_path, asset: asset }

          ary << ref
        end

        collected = @collected_assets.each_with_object([]) do |(full_path, assets), ary|
          ref = { full_path: full_path, assets: assets }

          ary << ref
        end

        {
          unassociated: @assets.values,
          scalar: scalar,
          collected: collected,
        }
      end

      def to_asset_source(identifier, url, name: nil, mime_type: nil)
        {
          identifier: identifier,
          url: url,
          name: name,
          mime_type: mime_type
        }.compact
      end
    end
  end
end
