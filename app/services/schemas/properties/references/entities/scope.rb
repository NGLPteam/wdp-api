# frozen_string_literal: true

module Schemas
  module Properties
    module References
      module Entities
        Scope = StoreModel.one_of do |json|
          target = json.fetch(:target, json["target"]).to_s

          case target
          when "any"
            Schemas::Properties::References::Entities::Scopes::Any
          when "links"
            Schemas::Properties::References::Entities::Scopes::Links
          when "siblings"
            Schemas::Properties::References::Entities::Scopes::Siblings
          else
            # We default to descendants if not otherwise specified
            Schemas::Properties::References::Entities::Scopes::Descendants
          end
        end
      end
    end
  end
end
