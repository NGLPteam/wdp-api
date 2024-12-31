# frozen_string_literal: true

module Introspection
  class RootLayoutsController < Introspection::BaseController
    def show
      version = SchemaVersion[params[:schema_version_id]]

      layout = version.root_layout_for params[:layout_kind]

      exported = layout.export!

      xml = exported.to_xml(pretty: true, declaration: true, encoding: true)

      render(xml:)
    end
  end
end
