# frozen_string_literal: true

module Harvesting
  module Metadata
    class ExtractModsEntities
      include Dry::Monads[:do, :result]
      include Dry::Effects.Resolve(:harvest_attempt)
      include Dry::Effects.Resolve(:harvest_record)
      include Dry::Effects.Resolve(:metadata_processor)
      include MonadicPersistence

      # @param [String] raw_metadata
      # @return [void]
      def call(raw_metadata)
        mods = Mods::Record.new.from_str raw_metadata

        yield produce_harvest_entity! mods

        Success nil
      end

      def harvest_entity_for(identifier)
        harvest_record.harvest_entities.by_identifier(identifier).first_or_initialize
      end

      def produce_harvest_entity!(mods)
        genre = yield extract_genre_for mods

        # We will do schema detection based on genre likely here
        # This could also produce multiple entities, but for now
        # only produces one

        identifier = yield extract_identifier mods

        he = harvest_entity_for identifier

        he.metadata_kind = genre

        he.extracted_attributes = yield extract_attributes_from mods

        he.schema_version = SchemaVersion["default:item"]

        monadic_save he
      end

      def extract_attributes_from(mods)
        attributes = {}

        attributes[:title] = yield extract_title_for mods
        attributes[:summary] = <<~TEXT
        ## MODS Genre
        #{yield extract_genre_for(mods)}

        ## Abstract
        #{(yield extract_first_text_for(mods.abstract)) || 'No abstract'}

        ## Subjects
        #{mods.subject.map(&:text).map(&:strip).join('; ').presence || '(none)'}
        TEXT

        attributes[:published_on] = yield extract_published_on_for mods

        Success attributes
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

      def extract_title_for(mods)
        found_title = mods.full_titles.first.presence ||
                      mods.short_titles.first.presence ||
                      mods.alternative_titles.first.presence

        return Success(found_title) if found_title.present?

        Success "Untitled Item (#{yield extract_identifier(mods)})"
      end

      def extract_first_text_for(selector, fallback: nil)
        Success selector&.first&.text.presence || fallback
      end

      def extract_published_on_for(mods)
        issue_date = mods.mods_ng_xml.at_xpath("/m:originInfo/m:dateIssued", "m" => Mods::MODS_NS)&.text

        case issue_date
        when /\A\d{4}\z/
          Success Date.parse("#{issue_date}-01-01")
        when %r,\A\d{4}[/.-]\d{2}[/.-]\d{2}\z,
          Success Date.parse issue_date
        when %r,\A\d{2}[/.-]\d{2}[/.-]\d{4}\z,
          Success Date.parse issue_date
        else
          Success nil
        end
      end
    end
  end
end
