# frozen_string_literal: true

module Schemas
  module Properties
    module References
      module Entities
        module Scopes
          class Links < Base
            string_enum :direction, :both, :incoming, :outgoing,
              default: "both",
              _prefix: :targets,
              _suffix: :links
          end
        end
      end
    end
  end
end
