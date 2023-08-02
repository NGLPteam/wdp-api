# frozen_string_literal: true

module Harvesting
  module Metadata
    module ValueExtraction
      module DSL
        class SetBuilder
          include Dry::Effects::Handler.Resolve
          include Dry::Effects.Resolve(:builder)
          include Dry::Initializer[undefined: false].define -> do
            param :identifier, Harvesting::Types::Identifier
          end
          include BuildsValues

          def initialize(*)
            super

            builder.set_mods[identifier] = []
          end

          def build(&block)
            provide(set: self) do
              instance_eval(&block)
            end

            Harvesting::Metadata::ValueExtraction::Set.new(identifier, @values)
          end

          def journal_source_issue_attrs!(from:, identifier_prefix: ?i, title_prefix: "Issue ", xpath_query: nil)
            value :identifier, type: :string, require_match: true do
              xpath xpath_query, type: :string do
                pipeline! do
                  xml_text

                  maybe_prefix identifier_prefix
                end
              end if xpath_query.present?

              from_value from, type: :string do
                pipeline! do
                  chain :volume

                  maybe_prefix identifier_prefix
                end
              end
            end

            value :id, type: :string, require_match: true do
              xpath xpath_query, type: :string do
                pipeline! do
                  xml_text
                end
              end if xpath_query.present?

              from_value from, type: :string do
                pipeline! do
                  chain :volume
                end
              end
            end

            value :number, type: :string, require_match: true do
              xpath xpath_query, type: :string do
                pipeline! do
                  xml_text
                end
              end if xpath_query.present?

              from_value from, type: :string do
                pipeline! do
                  chain :volume
                end
              end
            end

            value :sortable_number, type: :integer, require_match: true do
              xpath xpath_query, type: :string do
                pipeline! do
                  xml_text

                  metadata_operation "jats.parse_sortable_number"
                end
              end if xpath_query.present?

              from_value from, type: :string do
                pipeline! do
                  chain :volume

                  metadata_operation "jats.parse_sortable_number"
                end
              end
            end

            value :title, type: :string, require_match: true do
              xpath xpath_query, type: :string do
                pipeline! do
                  xml_text

                  maybe_prefix title_prefix
                end
              end if xpath_query.present?

              from_value from, type: :string do
                pipeline! do
                  chain :volume

                  maybe_prefix title_prefix
                end
              end
            end
          end

          def journal_source_volume_attrs!(from:, identifier_prefix: ?v, title_prefix: "Volume ", xpath_query: nil)
            value :identifier, type: :string, require_match: true do
              xpath xpath_query, type: :string do
                pipeline! do
                  xml_text

                  maybe_prefix identifier_prefix
                end
              end if xpath_query.present?

              from_value from, type: :string do
                pipeline! do
                  chain :volume

                  maybe_prefix identifier_prefix
                end
              end
            end

            value :id, type: :string, require_match: true do
              xpath xpath_query, type: :string do
                pipeline! do
                  xml_text
                end
              end if xpath_query.present?

              from_value from, type: :string do
                pipeline! do
                  chain :volume
                end
              end
            end

            value :number, type: :string, require_match: true do
              xpath xpath_query, type: :string do
                pipeline! do
                  xml_text
                end
              end if xpath_query.present?

              from_value from, type: :string do
                pipeline! do
                  chain :volume
                end
              end
            end

            value :sortable_number, type: :integer, require_match: true do
              xpath xpath_query, type: :string do
                pipeline! do
                  xml_text

                  metadata_operation "jats.parse_sortable_number"
                end
              end if xpath_query.present?

              from_value from, type: :string do
                pipeline! do
                  chain :volume

                  metadata_operation "jats.parse_sortable_number"
                end
              end
            end

            value :title, type: :string, require_match: true do
              xpath xpath_query, type: :string do
                pipeline! do
                  xml_text

                  maybe_prefix title_prefix
                end
              end if xpath_query.present?

              from_value from, type: :string do
                pipeline! do
                  chain :volume

                  maybe_prefix title_prefix
                end
              end
            end
          end

          # Modify the set-specific struct with a block.
          #
          # @return [void]
          def on_struct(&block)
            set_mods << block
          end

          private

          def set_mods
            builder.set_mods[identifier]
          end
        end
      end
    end
  end
end
