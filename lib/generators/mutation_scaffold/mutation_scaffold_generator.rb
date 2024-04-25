# frozen_string_literal: true

class MutationScaffoldGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  class_option :optional_description, type: :boolean, default: false
  class_option :unique_identifier, type: :boolean, default: false
  class_option :unique_title, type: :boolean, default: false
  class_option :skip_create, type: :boolean, default: false
  class_option :skip_destroy, type: :boolean, default: false
  class_option :skip_update, type: :boolean, default: false
  class_option :schema, type: :string, default: :tenant, desc: "Indicates which schemas will contain the mutation", banner: "tenant|control|all"

  # @return [void]
  def generate_mutations!
    generate_mutation! :create
    generate_mutation! :destroy
    generate_mutation! :update
  end

  private

  def generate_mutation!(verb)
    return if options[:"skip_#{verb}"]

    generate "mutation", mutation_generator_args_for(verb)
  end

  def has_unique_title?
    options[:unique_title]
  end

  def model_name
    class_name
  end

  def mutation_generator_args_for(verb)
    [].tap do |args|
      args << mutation_name_for(verb)

      args << "--unique-identifier" if options[:unique_identifier]
      args << "--unique-title" if has_unique_title?
      args << "--optional-description" if options[:optional_description]
      args << "--schema=#{options[:schema]}"
    end
  end

  def mutation_name_for(verb)
    prefix = verb.to_s.camelize(:upper)

    "#{model_name}#{prefix}"
  end
end
