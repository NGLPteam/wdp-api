# frozen_string_literal: true

# Generate an operation and service pair using our SimpleServiceOperation and HookBased::Actor
# conventions.
class ServiceOperationGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  DEFAULT_ABSTRACT_SERVICE = "Support::HookBased::Actor"

  argument :namespace, type: :string, required: true,
    desc: "The namespace that the services and operations should live in"

  argument :operation, type: :string, required: true,
    desc: "a verb, e.g. Create"

  argument :service, type: :string, required: true,
    desc: "a noun, e.g. Creator"

  class_option :abstract_service, type: :string, required: true,
    default: DEFAULT_ABSTRACT_SERVICE,
    desc: "The abstract class to inherit from."

  class_option :standard_execution, type: :boolean,
    #default: true,
    desc: "Whether to populate the service with the standard execution pattern (or leave it blank)"

  OPERATIONS = Rails.root.join("app", "operations")

  SERVICES = Rails.root.join("app", "services")

  def prepare!
    @abstract_service = options[:abstract_service].presence || DEFAULT_ABSTRACT_SERVICE
    @standard_execution = @options.fetch(:standard_execution) do
      abstract_service == DEFAULT_ABSTRACT_SERVICE
    end

    @namespace_name = ensure_constant(namespace)
    @namespace_parts = namespace_name.split("::")
    @namespace_path = namespace_parts.map { _1.underscore }

    @operation_name = ensure_constant(operation, klass: true)

    @operation_full_name = "#{namespace_name}::#{operation_name}"

    @operation_path = OPERATIONS.join(*namespace_path, "#{operation_name.underscore}.rb")

    @service_name = ensure_constant(service, klass: true)

    @service_full_name = "#{namespace_name}::#{service_name}"

    @service_path = SERVICES.join(*namespace_path, "#{service_name.underscore}.rb")
  end

  def generate_operation!
    template "operation.rb", operation_path
  end

  def generate_service!
    template "service.rb", service_path
  end

  private

  # @param [#to_s] input
  # @param [Boolean] klass whether to strip the namespace in case it's duped,
  #   we only want classes
  # @return [String]
  def ensure_constant(input, klass: false)
    input.to_s.camelize(:upper).then { klass ? _1.demodulize : _1 }
  end

  # @return [String]
  attr_reader :abstract_service

  # @return [String]
  attr_reader :full_operation_name

  # @return [String]
  attr_reader :full_service_name

  # @return [String]
  attr_reader :namespace_name

  # @return [<String>]
  attr_reader :namespace_path

  # @return [<String>]
  attr_reader :namespace_parts

  # @return [String]
  attr_reader :operation_full_name

  # @return [String]
  attr_reader :operation_name

  # @return [Pathname]
  attr_reader :operation_path

  # @return [String]
  attr_reader :service_full_name

  # @return [String]
  attr_reader :service_name

  # @return [Pathname]
  attr_reader :service_path

  # @return [Boolean]
  attr_reader :standard_execution

  alias standard_execution? standard_execution

  def nest(&)
    content = capture(&)

    namespace_parts.each_with_index do |part, index|
      indentation = "  " * index

      concat("#{indentation}module #{part}\n")
    end

    concat(content.indent(namespace_parts.size * 2))

    last_index = namespace_parts.length - 1

    last_index.downto(0).each do |index|
      indentation = "  " * index

      concat("#{indentation}end\n")
    end
  end
end
