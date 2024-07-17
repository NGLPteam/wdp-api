# frozen_string_literal: true

module ControlledVocabularies
  module Contracts
    # @abstract
    class Base < ApplicationContract
      config.types = ControlledVocabularies::TypeRegistry
    end
  end
end
