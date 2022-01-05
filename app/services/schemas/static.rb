# frozen_string_literal: true

module Schemas
  # This container namespace deals with services and operations tied to static, built-in schemas
  # that ship with WDP-API, as opposed to any user-space, custom schemas that may be added to an
  # installation at a later date.
  module Static
    extend Dry::Container::Mixin

    namespace "definitions" do
      register "map" do
        Schemas::Static::Definitions::Map.new
      end
    end

    namespace "metaschemas" do
      register "map" do
        Schemas::Static::Metaschemas::Map.new
      end
    end

    Import = Dry::AutoInject(self)
  end
end
