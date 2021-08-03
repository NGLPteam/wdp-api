# frozen_string_literal: true

module Schemas
  module Static
    # This is an abstract mapping that initializes a {Schemas::Static::VersionMap}
    # for a certain namespace, used to load and validate the static schema data
    # contained within the WDP.
    #
    # @abstract
    class AbstractMapping
      extend Dry::Core::ClassAttributes
      extend Memoist

      include Dry::Container::Mixin
      include Enumerable

      STATIC_ROOT = Rails.root.join("lib", "schemas")

      defines :root_namespace, type: Dry::Types["strict.string"]
      defines :namespaced_versions, type: Dry::Types["params.bool"]
      defines :version_map_klass, type: Dry::Types["strict.class"]

      root_namespace ""
      namespaced_versions false
      version_map_klass VersionMap

      alias identifiers keys

      def initialize(*)
        super

        populate!
      end

      def each
        return enum_for(__method__) unless block_given?

        identifiers.each do |identifier|
          resolve(identifier).each do |version|
            yield version
          end
        end
      end

      def each_definition
        return enum_for(__method__) unless block_given?

        identifiers.each do |identifier|
          yield identifier, resolve(identifier)
        end
      end

      def has_namespaced_versions?
        self.class.namespaced_versions
      end

      memoize def root
        STATIC_ROOT.join self.class.root_namespace
      end

      # @api private
      # @return [(String, Schemas::Static::VersionMap)]
      def to_version_map(child, namespace: nil)
        return nil unless child.directory?

        name = child.basename.to_s

        version_map = self.class.version_map_klass.new name

        child.glob("*.json") do |grandchild|
          version = grandchild.basename(".json").to_s

          version_map.add! name, version, grandchild, namespace: namespace
        end

        return name, version_map
      end

      private

      # @return [void]
      def populate!
        root.children.each do |child|
          next unless child.directory?

          if has_namespaced_versions?
            populate_namespace! child
          else
            populate_version! child
          end
        end
      end

      def populate_namespace!(child)
        mapping = self

        ns_name = child.basename.to_s

        mappings = child.children.map do |grandchild|
          name, version_map = mapping.to_version_map grandchild, namespace: ns_name

          [name, version_map].map(&:presence).compact.presence
        end.compact

        namespace ns_name do
          mappings.each do |(name, version_map)|
            register name, version_map
          end
        end
      end

      def populate_version!(child)
        name, version_map = to_version_map child

        return if name.blank? || version_map.blank?

        register name, version_map
      end
    end
  end
end
