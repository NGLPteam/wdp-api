# frozen_string_literal: true

# A controller that provides example queries for working with this API.
class ExampleQueriesController < ApplicationController
  # @return [void]
  def index
    render json: ExampleQuery.all
  end
end
