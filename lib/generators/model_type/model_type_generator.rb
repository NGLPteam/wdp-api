# frozen_string_literal: true

require_relative "../../support/system"

class ModelTypeGenerator < Rails::Generators::NamedBase
  include Support::GeneratesCommonFields
  include Support::GeneratesGQLFields

  source_root File.expand_path("templates", __dir__)

  def create_type!
    template "model.rb", Rails.root.join("app/graphql/types", "#{graphql_file_name}.rb")
  end

  private

  def graphql_file_name
    graphql_type_name.underscore
  end

  def graphql_type_name
    "#{class_name}Type"
  end

  def model_name
    class_name
  end
end
