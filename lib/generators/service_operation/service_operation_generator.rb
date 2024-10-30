# frozen_string_literal: true

# Generate an operation and service pair using our SimpleServiceOperation and HookBased::Actor
# conventions.
class ServiceOperationGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  argument :namespace, type: :string, required: true,
    desc: "The namespace that the services and operations should live in"

  argument :operation, type: :string, required: true,
    desc: "a verb, e.g. Create"

  argument :service, type: :string, required: true,
    desc: "a noun, e.g. Creator"

  OPERATIONS = Rails.root.join("app", "operations")

  SERVICES = Rails.root.join("app", "services")

  def prepare!
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
