# frozen_string_literal: true

module Seeding
  # @see Seeding::Export::RootExporter
  class ExportRoot
    include Dry::Monads[:result]

    def call(**options)
      exporter = Seeding::Export::RootExporter.new(**options)

      Success exporter.call
    end
  end
end
