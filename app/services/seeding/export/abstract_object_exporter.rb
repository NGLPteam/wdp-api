# frozen_string_literal: true

module Seeding
  module Export
    # @abstract
    class AbstractObjectExporter < AbstractExporter
      param :input, Seeding::Types::Any
    end
  end
end
