# frozen_string_literal: true

module Mutations
  # @abstract
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    include Graphql::PunditHelpers

    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    delegate :attribute_names, :error_compiler, to: :class

    def app_container
      WDPAPI::Container
    end

    def resolve_container_value(*args)
      app_container.resolve(*args)
    end

    def perform_operation(name, **args)
      middleware = MutationOperations::Middleware.new(
        attribute_names: attribute_names,
        context: context,
        error_compiler: self.class.error_compiler,
        mutation: self,
        operation_name: name,
      )

      operation = resolve_container_value name

      middleware.call operation, **args
    end

    def perform_simple_operation(name, *args, &block)
      operation = resolve_container_value name

      result = operation.call(*args)

      Dry::Matcher::ResultMatcher.call(result, &block)
    end

    class << self
      # @!attribute [r] attribute_names
      # @see Types::BaseArgument#attribute_names
      # @return [<String>]
      def attribute_names
        @attribute_names ||= arguments.values.map(&:attribute_names).reduce(&:+)
      end

      # @return [void]
      def clearable_attachment!(attachment_name, prefix: "clear", **options, &block)
        full_name = [prefix, attachment_name].compact.join(?_).to_sym

        options[:attribute] = true
        options[:required] = false
        options[:default_value] = false

        options[:description] ||= <<~TEXT.strip_heredoc
        If set to true, this will clear the attachment #{attachment_name} on this model.
        TEXT

        argument full_name, GraphQL::Types::Boolean, **options, &block
      end

      # @!attribute [r] error_compiler
      # @return [MutationOperations::ErrorCompiler]
      def error_compiler
        @error_compiler ||= MutationOperations::ErrorCompiler.new attribute_names: attribute_names
      end

      # @param [String] name
      # @return [void]
      def performs_operation!(name, standard_mutation: true, destroy: false)
        standard_mutation! if standard_mutation
        destroy_mutation! if destroy

        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        def resolve(**args)
          perform_operation(#{name.inspect}, **args)
        end
        RUBY
      end

      # @return [void]
      def standard_mutation!
        payload_type.implements Types::StandardMutationPayload
      end

      # @return [void]
      def destroy_mutation!
        payload_type.implements Types::DestroyMutationPayloadType
      end

      # @param [Symbol] attachment_name
      # @return [void]
      def image_attachment!(attachment_name, required: false, has_metadata: true)
        argument attachment_name, Types::UploadedFileInputType, required: required, attribute: true do
          description <<~TEXT.strip_heredoc
          A reference to an uploaded image in Tus.
          TEXT
        end

        add_image_metadata_input! attachment_name if has_metadata
      end

      # @param [Symbol] attachment_name
      # @return [void]
      def add_image_metadata_input!(attachment_name)
        full_name = :"#{attachment_name}_metadata"

        options = {}

        options[:attribute] = true
        options[:required] = false
        options[:description] = <<~TEXT
        Metadata for an image attachment.
        TEXT

        argument full_name, Types::ImageMetadataInputType, options
      end
    end
  end
end
