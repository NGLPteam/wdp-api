# frozen_string_literal: true

module Schemas
  module Static
    class Generate
      module NGLP
        # @api private
        class Dissertation < Schemas::Static::Generator
          def generate
            set! "title", Faker::Book.title
            set! "subtitle", Faker::Lorem.sentence

            set_degree_grantor!

            set_random_option! "type_of_resource"
            set_random_option! "genre"

            created = Faker::Date.backward(days: 365 * 30)

            set! "origin_information.date_created", created
            set! "origin_information.date_issued", Faker::Date.between(from: created, to: Date.current)

            set_random_option! "language"

            set_physical_description!

            calculate! :abstract do |props|
              random_markdown(title: props[:title], subtitle: props[:subtitle])
            end

            set! "subject", Faker::Book.genre

            set_degree_information!
          end

          private

          def set_degree_grantor!
            set! "degree_grantor.university", Faker::Educator.university

            set_random_option! "degree_grantor.department"
          end

          def set_physical_description!
            set_random_option! "physical_description.form"

            set_random_option! "physical_description.digital_origin"
          end

          def set_degree_information!
            set_random_option! "degree_information.name"
            set_random_option! "degree_information.level"
          end
        end
      end
    end
  end
end
