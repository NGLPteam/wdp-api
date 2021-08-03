# frozen_string_literal: true

module Schemas
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
