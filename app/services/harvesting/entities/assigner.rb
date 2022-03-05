# frozen_string_literal: true

module Harvesting
  module Entities
    class Assigner
      include Dry::Monads::Do.for(:realize)
      include WDPAPI::Deps[chain_method: "utility.chain_method"]

      def initialize(*)
        super

        @metadata_kind = nil
        @attributes = {}.with_indifferent_access
        @props = ::PropertyHash.new
        @assets = {}
        @incoming_collections = []
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

      # @param [Object] origin
      # @param [Hash] mapping
      def attributes_from!(origin, mapping)
        mapping.each do |target, source|
          attr! target, chain_method.call(origin, source)
        end
      end

      alias attrs_from! attributes_from!

      # @param [String] full_path The full path for the schema property. Supports dot notation.
      # @param [Object] value the value for the schema property
      # @return [self]
      def property!(full_path, value)
        @props[full_path] = realize(value).value!

        return self
      end

      alias prop! property!

      # @param [Object] origin
      # @param [Hash] mapping
      # @return [self]
      def properties_from!(origin, mapping)
        mapping.each do |target, source|
          prop! target, chain_method.call(origin, source)
        end

        return self
      end

      alias props_from! properties_from!

      def attrs_and_props_from!(origin, attrs, props)
        attrs_from! origin, attrs
        props_from! origin, props

        return self
      end

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

      # @param [String] identifier
      # @param ["contains", "references"] operator
      # @return [self]
      def link_collection!(identifier, operator: "contains")
        @incoming_collections << Harvesting::Links::Source.new(identifier: identifier, operator: operator)

        return self
      end

      # Assign multiple asset types at once from mappings and arrays
      #
      # @param [{ #to_s => <#to_assigner> }] collected
      # @param [{ #to_s => #to_assigner, nil }] scalar
      # @param [<#to_assigner>] unassociated
      # @return [self]
      def assets!(collected: {}, scalar: {}, unassociated: [])
        collected_assets! collected

        scalar_assets! scalar

        unassociated_assets! unassociated

        return self
      end

      # @return [self]
      def unassociated_asset!(identifier, url, **props)
        @assets[identifier] = to_asset_source(identifier, url, props)

        return self
      end

      # @param [<#to_assigner>] assets
      # @return [self]
      def unassociated_assets!(assets)
        assets.each do |asset|
          unassociated_asset!(*asset.to_assigner)
        end

        return self
      end

      # @return [self]
      def scalar_asset!(full_path, identifier, url, **props)
        @scalar_assets[full_path] = to_asset_source(identifier, url, props)

        return self
      end

      # @param [{ #to_s => #to_assigner }] mapping
      # @return [self]
      def scalar_assets!(mapping)
        mapping.each do |full_path, asset|
          scalar_asset! full_path, *asset.to_assigner
        end

        return self
      end

      # @return [self]
      def collected_asset!(full_path, identifier, url, **props)
        @collected_assets[full_path] ||= []

        @collected_assets[full_path].push(to_asset_source(identifier, url, props))

        return self
      end

      # @param [{ #to_s => #to_assigner }] mapping
      # @return [self]
      def collected_assets!(mapping)
        mapping.each do |full_path, assets|
          assets.each do |asset|
            collected_asset! full_path, *asset.to_assigner
          end
        end

        return self
      end

      def to_attributes
        {
          metadata_kind: @metadata_kind,
          extracted_attributes: compile_attributes,
          extracted_properties: compile_properties,
          extracted_assets: compile_assets,
          extracted_links: compile_links,
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

      def compile_links
        {
          incoming_collections: @incoming_collections,
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
