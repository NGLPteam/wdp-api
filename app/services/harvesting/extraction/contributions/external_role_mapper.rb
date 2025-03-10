# frozen_string_literal: true

module Harvesting
  module Extraction
    module Contributions
      # This class is responsible for remapping "external" role identifiers
      # to ones used within Meru. For instance, in Janeway, an author might
      # be described as `"author"`, but within the MARC Relator Codes
      # {ControlledVocabulary}, it would be `"aut"`. In this case, the {#from}
      # value would be `"author"`, and the {#to} value would be `"aut"`.
      class ExternalRoleMapper < Support::FlexibleStruct
        attribute :from, Harvesting::Types::String.constrained(filled: true)
        attribute :to, Harvesting::Types::String.constrained(filled: true)
        attribute? :case_insensitive, Harvesting::Types::Bool.default(false)

        # @param [String] role_name
        def match?(role_name)
          case_insensitive ? from.casecmp(role_name).zero? : from == role_name
        end
      end
    end
  end
end
