# frozen_string_literal: true

# Models with this concern can iterate over schema properties,
# produce a schema property context, etc.
#
# @see HasSchemaDefinition
# @see SchemaVersion
module ExposesSchemaProperties
  extend ActiveSupport::Concern

  # @see Schemas::Properties::Extract
  # @return [<Schemas::Properties::BaseDefinition>]
  def extract_schema_properties
    call_operation("schemas.properties.extract", self)
  end

  # Transform this model's schema properties into an array of readers to be consumed
  # by the GraphQL API for deterministically-ordered iteration.
  #
  # @see Schemas::Instances::ReadProperties
  # @param [Schemas::Properties::Context, nil] context
  # @return [Dry::Monads::Success<Schemas::Properties::Reader, Schemas::Properties::GroupReader>]
  def read_properties(context: nil)
    call_operation("schemas.properties.to_readers", self, context: context)
  end

  # Generate a reader for a single property.
  #
  # @see Schemas::Properties::FetchReader
  # @param [String] full_path
  # @param [Schemas::Properties::Context, nil] context
  # @return [Dry::Monads::Success(Schemas::Properties::Reader)]
  # @return [Dry::Monads::Success(Schemas::Properties::GroupReader)]
  # @return [Dry::Monads::Failure(Symbol, String)]
  def read_property(full_path, context: nil)
    call_operation("schemas.properties.fetch_reader", self, full_path, context: context)
  end

  # Fetch a reader for a property known to exist, or raise an error.
  #
  # @see #read_property
  # @param [String] full_path
  # @param [Schemas::Properties::Context, nil] context
  # @raise [Dry::Monads::UnwrapError]
  # @return [Schemas::Properties::Reader, Schemas::Properties::GroupReader]
  def read_property!(full_path, context: nil)
    read_property(full_path, context: context).value!
  end

  # Fetch the property context for this model's schema.
  #
  # When this is called by a schema version, there will be no values
  # applied to the context, but it can still be used to render a form
  # for creating a new schema instance.
  #
  # @see Schemas::Properties::ToContext
  # @return [Schema::Properties::Context]
  def read_property_context
    call_operation("schemas.properties.to_context", self).value!
  end

  # @note This only really makes sense for schema instances, but it will
  #   work when called from a schema version.
  # @see #read_property
  # @param [String] full_path
  # @param [Schemas::Properties::Context, nil] context
  # @return [Dry::Monads::Result]
  def read_property_value(full_path, context: nil)
    read_property(full_path, context: context).tee(&:must_be_scalar).fmap(&:value)
  end

  # Read the value for a property known to exist, or raise an error.
  #
  # @see #read_property_value
  # @param [String] full_path
  # @param [Schemas::Properties::Context, nil] context
  # @raise [Dry::Monads::UnwrapError]
  # @return [Object]
  def read_property_value!(full_path, context: nil)
    read_property_value(full_path, context: context).value!
  end

  # @api private
  # @note This method is used for debugging in the console.
  # @see Schema::Properties::Context#field_values
  # @return [Hash]
  def read_property_values
    read_property_context.field_values
  end
end
