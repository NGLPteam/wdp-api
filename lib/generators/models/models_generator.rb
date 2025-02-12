# frozen_string_literal: true

require "rails/generators/active_record"
require_relative "dsl/schema"
require "securerandom"

class ModelsGenerator < Rails::Generators::Base
  include ActiveRecord::Generators::Migration

  source_root File.expand_path("templates", __dir__)

  class_option :skip_migrations, type: :boolean, default: false

  argument :path, type: :string

  attr_reader :models, :model, :run_token, :reference

  def initialize(...)
    @run_token = SecureRandom.uuid
    super
  end

  def load_schema
    @schema = DSL::Schema.new
    @schema.evaluate_file(File.join(Dir.pwd, path))
  end

  def ensure_statesman_concern
    return unless @schema.any_state_machine?

    template "uses_statesman.rb", File.join("app/models/concerns", "uses_statesman.rb")
  end

  def ensure_timestamp_scopes
    template "timestamp_scopes.rb", File.join("app/models/concerns", "timestamp_scopes.rb")
  end

  def scaffold_models
    @schema.models.each do |model|
      set_current_model(model)
      create_migration_file
      create_state_machine
      create_state_machine_transition_model
      create_state_machine_migration
      create_state_machine_gql_type
      create_polymorphic_concerns
      create_model_file
      create_policy_file
      create_factory
      create_model_spec
      create_model_gql_type
      create_model_gql_interface
      create_mutations
      clear_current_model
    end
  end

  def add_models_to_type_registry
    @schema.models.each do |model|
      inject_into_tye_registry(<<~RUBY)
      tc.add_model! "#{model.class_name}"
      RUBY
    end
  end

  def add_polymorphic_concerns_to_type_registry
    @schema.polymorphic_gql_references.each do |reference|
      inject_into_tye_registry(<<~RUBY)
      tc.add! :#{reference.name}, ::#{reference.source_model.module_name}::Types::#{reference.concern_class_name}
      RUBY
    end
  end

  private

  def inject_into_tye_registry(text)
    inject_into_file "app/services/shared/type_registry.rb", before: "    # Generator End" do
      text.indent(4)
    end
  end

  def create_model_gql_interface
    return unless @model.gql_interface?

    args = [@model.class_name]
    args.push "--force" if forced?
    Rails::Generators.invoke("model_interface", args)
  end

  def create_mutations
    return if @model.defined_mutations.empty?

    @model.defined_mutations.each do |mutation|
      Rails::Generators.invoke("mutation", mutation.generator_args(forced: forced?))
    end
  end

  def create_model_gql_type
    return unless @model.gql_type?

    template "model_gql_type.rb", Rails.root.join("app/graphql/types", "#{@model.graphql_file_name}.rb")
  end

  def create_polymorphic_concerns
    return unless @model.polymorphic_gql_references?

    template "model_types.rb", Rails.root.join("app/services/#{@model.plural_name}", "types.rb")

    @model.polymorphic_gql_references.each do |reference|
      @reference = reference
      template "polymorphic_concern.rb", Rails.root.join("app/models/concerns", "#{@reference.concern_file_name}.rb")
      template "polymorphic_gql_union_type.rb", Rails.root.join("app/graphql/types", "#{@reference.gql_type_file_name}.rb")
      @reference = nil
    end
  end

  def create_state_machine
    return unless @model.state_machine?

    template "state_machine.rb", File.join("app/services", @model.file_name.pluralize, "state_machine.rb")
  end

  def create_state_machine_migration
    return unless @model.state_machine?
    return if skip_migration_creation?

    saved_reference = @model
    @model = @model.state_machine.transition_model
    create_migration_file
    @model = saved_reference
  end

  def create_state_machine_gql_type
    return unless @model.state_machine?
    template "state_machine_gql_type.rb", File.join("app/graphql/types", "#{@model.file_name}_state_type.rb")
  end

  def create_state_machine_transition_model
    return unless @model.state_machine?

    saved_reference = @model
    @model = @model.state_machine.transition_model
    create_model_file
    @model = saved_reference
  end

  def create_migration_file
    return if skip_migration_creation?

    migration_template "migration.rb", File.join(db_migrate_path, "create_#{@model.table_name}.rb")
  end

  def create_model_file
    template "model.rb", File.join("app/models", "#{@model.file_name}.rb")
  end

  def create_policy_file
    template "policy.rb", File.join("app/policies", "#{@model.file_name}_policy.rb")
  end

  def create_factory
    template "factory.rb", File.join("spec/factories", "#{@model.plural_name}.rb")
  end

  def create_model_spec
    template "model_spec.rb", File.join("spec/models", "#{@model.file_name}_spec.rb")
  end

  def set_current_model(model)
    @model = model
  end

  def clear_current_model
    @model = nil
  end

  def skip_migration_creation?
    options[:skip_migrations] == true
  end

  def forced?
    options[:force] == true
  end
end
