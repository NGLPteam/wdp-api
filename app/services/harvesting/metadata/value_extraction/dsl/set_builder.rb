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

          def journal_source_issue_attrs!(from:, identifier_prefix: ?i, title_prefix: "Issue ")
            compose_value :identifier, from: from, type: :string, require_match: true do
              pipeline! do
                chain :issue

                maybe_prefix identifier_prefix
              end
            end

            compose_value :id, from: from, type: :string, require_match: true do
              pipeline! do
                chain :issue
              end
            end

            compose_value :number, from: from, type: :string, require_match: true do
              pipeline! do
                chain :issue
              end
            end

            compose_value :sortable_number, from: from, type: :integer, require_match: true do
              pipeline! do
                chain :issue

                metadata_operation "jats.parse_sortable_number"
              end
            end

            compose_value :title, from: from, type: :string, require_match: true do
              pipeline! do
                chain :issue

                maybe_prefix title_prefix
              end
            end
          end

          def journal_source_volume_attrs!(from:, identifier_prefix: ?v, title_prefix: "Volume ")
            compose_value :identifier, from: from, type: :string, require_match: true do
              pipeline! do
                chain :volume

                maybe_prefix identifier_prefix
              end
            end

            compose_value :id, from: from, type: :string, require_match: true do
              pipeline! do
                chain :volume
              end
            end

            compose_value :number, from: from, type: :string, require_match: true do
              pipeline! do
                chain :volume
              end
            end

            compose_value :sortable_number, from: from, type: :integer, require_match: true do
              pipeline! do
                chain :volume

                metadata_operation "jats.parse_sortable_number"
              end
            end

            compose_value :title, from: from, type: :string, require_match: true do
              pipeline! do
                chain :volume

                maybe_prefix title_prefix
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
