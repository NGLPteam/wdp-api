# frozen_string_literal: true

module NamedVariableDates
  class << self
    # @yieldparam [Symbol] name
    # @yieldreturn [void]
    # @return [void]
    def each_collection
      return enum_for(__method__) unless block_given?

      NamedVariableDates::Types::COLLECTION.each do |name|
        yield name
      end
    end

    # @yieldparam [Symbol] name
    # @yieldreturn [void]
    # @return [void]
    def each_shared
      return enum_for(__method__) unless block_given?

      NamedVariableDates::Types::SHARED.each do |name|
        yield name
      end
    end
  end
end
