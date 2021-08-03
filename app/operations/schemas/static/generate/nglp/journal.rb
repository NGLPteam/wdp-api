# frozen_string_literal: true

module Schemas
  module Static
    class Generate
      module NGLP
        # @api private
        class Journal < Schemas::Static::Generator
          def generate
            set! "publisher.name", Faker::Book.publisher

            set! "publisher.email", Faker::Internet.safe_email, skip_chance: 50

            set! "publisher.collaborators", Contributor.sample(3)

            set! :collected_on, Faker::Date.backward

            set_random_option! "grouping.category"

            set! "grouping.tags", random_colors
          end
        end
      end
    end
  end
end
