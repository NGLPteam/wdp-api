# frozen_string_literal: true

module Harvesting
  module Testing
    module OAI
      module Broken
        class Model < ::OAI::Provider::Model
          def earliest
            raise ::OAI::Exception.new("This provider does not work.")
          end

          alias latest earliest

          alias sets earliest

          def deleted?(...)
            false
          end

          def find(...)
            raise ::OAI::Exception.new("This provider does not work.")
          end
        end
      end
    end
  end
end
