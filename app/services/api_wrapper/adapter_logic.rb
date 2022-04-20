# frozen_string_literal: true

module APIWrapper
  # Methods to be included in GraphQL Client Adapters
  #
  # @api private
  module AdapterLogic
    # @param [{ Symbol => Object }] context
    # @return [{ String => String }]
    def headers(context)
      {}.tap do |h|
        h["Authorization"] = "Bearer #{context[:token]}" if context[:token].present?
      end
    end
  end
end
