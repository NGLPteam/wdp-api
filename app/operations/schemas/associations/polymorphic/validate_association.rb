# frozen_string_literal: true

module Schemas
  module Associations
    module Polymorphic
      # A wrapper around {Schemas::Associations::Validate} that is intended
      # to be called with two polymorphic types, for general-purpose validation
      #
      # @see Schemas::Associations::Validate
      # @see Schemas::Utility::VersionFor
      class ValidateAssociation
        include Dry::Matcher.for(:call, with: Schemas::Associations::Matchers::Connection)
        include WDPAPI::Deps[
          validate: "schemas.associations.validate",
          version_for: "schemas.utility.version_for"
        ]

        # @see Schemas::Associations::Validate#call
        # @param [SchemaVersion, Object] parent (@see Schemas::Utility::VersionFor)
        # @param [SchemaVersion, Object] child (@see Schemas::Utility::VersionFor)
        # @yield [matcher]
        # @yieldparam [Schemas::Associations::Matchers::Connection] matcher
        # @yieldreturn [void]
        # @return [Dry::Monads::Success(Schemas::Associations::Validations::ValidConnection)]
        # @return [Dry::Monads::Failure(Schemas::Associations::Validations::InvalidChild)]
        # @return [Dry::Monads::Failure(Schemas::Associations::Validations::InvalidParent)]
        # @return [Dry::Monads::Failure(Schemas::Associations::Validations::MutuallyInvalidConnection)]
        def call(parent, child)
          parent_version = parent.kind_of?(SchemaVersion) ? parent : version_for.(parent)

          child_version = child.kind_of?(SchemaVersion) ? child : version_for.(child)

          validate.call(parent_version, child_version)
        end
      end
    end
  end
end
