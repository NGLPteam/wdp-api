# frozen_string_literal: true

module Schemas
  module Static
    class Generate
      module NGLP
        # @api private
        class Article < Schemas::Static::Generator
          def generate
            set! :authored_on, Faker::Date.backward(days: 365 * 30)

            set_publisher!

            # set! :header, header_asset
            # set! :pdf, pdf_asset

            set_revision!

            set_grouping!

            set_text_content!
          end

          private

          def set_publisher!
            set! "publisher.name", Faker::Book.publisher

            set! "publisher.email", Faker::Internet.safe_email, skip_chance: 50

            set! "publisher.collaborators", Contributor.sample(3)
          end

          def set_revision!
            set! "revision.reviser", Contributor.person.sample.to_encoded_id

            set_random_boolean! "revision.published", chance: 70

            set! "revision.published", percentage(70)
          end

          # @return [void]
          def set_grouping!
            set_random_option! "grouping.category"

            set! "grouping.tags", random_colors
          end

          # @return [void]
          def set_text_content!
            set! "title", Faker::Book.title

            calculate! :body do |props|
              <<~MARKDOWN.strip_heredoc
              # #{props[:title]}

              Category: #{props[:grouping][:category]}
              Tags: #{props[:grouping][:tags].map { |tag| "##{tag}" }.join(', ')}
              Published by: #{compile_publisher(props)}
              Revision: #{props[:revision].fetch(:number, 0)}

              ## Matz wisdom

              #{Faker::Quote.matz}

              ## Content

              #{Faker::Lorem.paragraph(sentence_count: 5..10)}
              MARKDOWN
            end
          end

          # @return [String]
          def compile_publisher(props)
            props[:publisher].then do |publisher|
              return publisher[:name] if publisher[:email].blank?

              <<~MARKDOWN.strip_heredoc
              [#{publisher[:name]}](mailto:#{publisher[:email]})
              MARKDOWN
            end
          end
        end
      end
    end
  end
end
