# frozen_string_literal: true

module Harvesting
  module Metadata
    module MODS
      class ExtractEntities < Harvesting::Metadata::BaseEntityExtractor
        # @param [String] raw_metadata
        # @return [void]
        def call(raw_metadata)
          mods = Mods::Record.new.from_str raw_metadata

          yield produce_harvest_entity! mods

          Success nil
        end

        private

        def produce_harvest_entity!(mods)
          genre = yield extract_genre_for mods

          # We will do schema detection based on genre likely here
          # This could also produce multiple entities, but for now
          # only produces one

          identifier = yield extract_identifier mods

          entity = find_or_create_entity identifier

          with_entity.(entity) do |assigner|
            assigner.genre! genre

            assigner.attr! :title, extract_title_for(mods)
            assigner.attr! :issued, extract_issued_for(mods)
            assigner.attr! :summary, extract_summary_from(mods)

            assigner.schema! schemas[:default_item]
          end
        end

        def extract_summary_from(mods)
          summary = <<~TEXT
          ## MODS Genre
          #{yield extract_genre_for(mods)}

          ## Abstract
          #{(yield extract_first_text_for(mods.abstract)) || 'No abstract'}

          ## Subjects
          #{mods.subject.map(&:text).map(&:strip).join('; ').presence || '(none)'}
          TEXT

          Success summary
        end

        def extract_identifier(mods)
          mods.identifier.text.presence.then do |identifier|
            if identifier.present?
              Success identifier
            else
              Failure[:unknown_identifier, "Unable to extract identifier"]
            end
          end
        end

        def extract_genre_for(mods)
          extract_first_text_for mods.genre, fallback: "unknown"
        end

        TITLE_KEYS = %i[full_titles short_titles alternative_titles].freeze

        def extract_title_for(mods)
          TITLE_KEYS.each do |title_key|
            titles = Array(mods.public_send(title_key))

            titles.each do |title|
              return Success(title) if title.present?
            end
          end

          # :nocov:
          Success "Untitled Item (#{yield extract_identifier(mods)})"
          # :nocov:
        end

        def extract_first_text_for(selector, fallback: nil)
          Success selector&.first&.text.presence || fallback
        end

        def extract_issued_for(mods)
          issue_date = mods.mods_ng_xml.at_xpath("/m:originInfo/m:dateIssued", "m" => ::Mods::MODS_NS)&.text

          parse_variable_precision_date.call(issue_date)
        end
      end
    end
  end
end
