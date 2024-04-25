# frozen_string_literal: true

require_relative "concerns/with_name"

module DSL
  class TypeAlias
    attr_reader :type, :options

    include WithName

    def initialize(name, type, options = {})
      @name = name
      @type = type
      @options = options
    end
  end
end
