# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroETD
    class EsploroETD < EsploroSchema::Common::AbstractComplexType
      # For ETDs. The institution which granted the degree. Free-text.
      property! :degree_grantor, :string

      # Calculated field. Do not insert any values here.
      property! :degree_level, :string

      # The name of the ETD degree awarded. Use value from code table.
      property! :degree_name, :string

      # The ETD degree program (degree in). Use value from code table.
      property! :degree_program, :string

      # Calculated field. Do not insert any values here.
      property! :degree_discipline, :string, collection: true

      # Primary thesis topic.
      # Use value from code table.
      # Multiple values are allowed.
      # ANZ customers have a designated code table.
      property! :primary_subjects, :string, collection: true

      # Secondary thesis topic.
      # Use value from code table.
      # Multiple values are allowed.
      # ANZ customers have a designated code table.
      property! :secondary_subjects, :string, collection: true

      # Not relevant for import/export.
      property! :full_primary_subjects, :string, collection: true

      # Not relevant for import/export.
      property! :full_secondary_subjects, :string, collection: true

      # For future use (not yet supported).
      property! :citizenship_author, :string

      # Type of ETD project. Use value from code table.
      # Code	Description
      # capstone	Capstone
      # dissertation	Dissertation
      # essay	Essay
      # exegesis	Exegesis
      # lecture	Lecture Recital
      # treatise	Treatise
      property! :diss_type, :string

      # Provenance (The history of the ownership). Free-text. Relevant for ETDs.
      property! :provenance, :string

      # Not relevant for import/export.
      property! :degree_level_with_desc, :string, collection: true

      xml do
        root "etd", mixed: true

        map_element "degree.grantor", to: :degree_grantor
        map_element "degree.level", to: :degree_level
        map_element "degree.name", to: :degree_name
        map_element "degree.program", to: :degree_program
        map_element "degree.discipline", to: :degree_discipline
        map_element "degree.primarysubject", to: :primary_subjects
        map_element "degree.secondarysubject", to: :secondary_subjects
        map_element "degreePrimarySubjectFull", to: :full_primary_subjects
        map_element "degreeSecondarySubjectFull", to: :full_secondary_subjects
        map_element "citizenship.author", to: :citizenship_author
        map_element "diss.type", to: :diss_type
        map_element "provenance", to: :provenance
        map_element "degreeLevelWithDesc", to: :degree_level_with_desc
      end
    end
  end
end
