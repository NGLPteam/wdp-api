# frozen_string_literal: true

module Introspection
  class SchemaVersionsController < Introspection::BaseController
    def show
      version = SchemaVersion[params[:id]]

      render json: version.to_json
    end
  end
end
