# frozen_string_literal: true

module Schemas
  module Static
    # @abstract
    class VersionMap
      extend Dry::Core::ClassAttributes
      extend Dry::Initializer

      defines :version_klass, type: Dry::Types["strict.class"]

      include ActiveModel::Validations
      include Dry::Core::Memoizable
      include Enumerable

      param :name, AppTypes::String

      version_klass Schemas::Static::Version

      delegate :each, to: :versions

      validate :has_versions!

      alias latest first

      def [](version)
        cache.compute_if_absent version do
          versions.detect do |v|
            v.version == version
          end
        end
      end

      def add!(name, version, path, **options)
        instance = self.class.version_klass.new name, version, path, **options

        versions << instance

        return self
      end

      def blank?
        versions.empty?
      end

      memoize def cache
        Concurrent::Map.new
      end

      memoize def versions
        SortedSet.new
      end

      private

      def has_versions!
        errors.add :base, "must have at least 1 version" if versions.blank?
      end
    end
  end
end
