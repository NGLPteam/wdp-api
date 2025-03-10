# frozen_string_literal: true

module Harvesting
  module Testing
    module OAI
      # Sample record concern for supplying records to our test OAI providers.
      module SampleRecord
        extend ActiveSupport::Concern

        include Dry::Core::Constants
        include Dry::Core::Equalizer.new(:identifier)

        included do
          extend Dry::Core::ClassAttributes

          defines :metadata_format_name, type: Harvesting::Types::MetadataFormatName
          defines :metadata_format, type: Harvesting::Testing::Types::MetadataFormat
          defines :metadata_prefix, type: Harvesting::Types::String

          self.primary_key = :identifier

          add_index :identifier, unique: true

          default_attributes!(
            deleted: false,
            set_specs: EMPTY_ARRAY,
          )

          scope :in_provider_order, -> { order(identifier: :asc) }

          calculates! :full_identifier do |record|
            "meru:oai:#{metadata_format_name}:#{record["identifier"]}"
          end

          calculates! :set_matcher do |record|
            ::Harvesting::Testing::OAI::SetSpecMatcher.new(record["set_specs"])
          end
        end

        # @return [HarvestMetadataFormat]
        def metadata_format
          self.class.metadata_format
        end

        # @return [Harvesting::Types::MetadataFormatName]
        def metadata_format_name
          self.class.metadata_format_name
        end

        # @return [<Harvesting::Testing::OAI::Set>]
        def sets
          @sets ||= ::Harvesting::Testing::OAI::Set.where(spec: set_specs).to_a
        end

        module ClassMethods
          def by_set(spec)
            return all if spec.blank?

            set_matcher = Harvesting::Testing::OAI::SetSpecMatcher.matcher_for(spec)

            where(set_matcher:)
          end

          # @param [HarvestSource] harvest_source
          # @return [Harvesting::Testing::OAI::SampleRecord, nil]
          def available_sample_for(harvest_source)
            existing_ids = harvest_source.harvest_records.pluck(:identifier)

            where.not(identifier: existing_ids).first
          end

          def since_identifier(last_identifier)
            return all if last_identifier.blank? || last_identifier == ?0

            identifier = first_identifier..last_identifier

            where.not(identifier:)
          end

          def first_identifier
            @first_identifier ||= in_provider_order.minimum(:identifier)
          end

          # @return [void]
          def record_schema!(raw_metadata, &)
            define_metadata!(raw_metadata)

            schema!(types: ::Harvesting::Testing::TypeRegistry) do
              required(:identifier).value(:identifier)
              required(:full_identifier).value(:identifier)
              required(:changed_at).filled(:time)
              required(:deleted).value(:bool)
              required(:metadata_source).filled(:string)
              required(:set_specs).value(:oai_set_specs)
              required(:set_matcher).value(Harvesting::Testing::Types.Instance(::Harvesting::Testing::OAI::SetSpecMatcher))

              instance_eval(&)
            end

            add_metadata_source_accessor!
          end

          # @return [Harvesting::Testing::OAI::ModelWrapper]
          def wrapped
            @wrapped ||= Harvesting::Testing::OAI::ModelWrapper.new(self)
          end

          private

          # @param [Harvesting::Types::MetadataFormatName] name
          # @return [void]
          def define_metadata!(name)
            metadata_format_name Harvesting::Types::MetadataFormatName[name]

            metadata_format HarvestMetadataFormat.find(metadata_format_name)

            metadata_prefix metadata_format.oai_metadata_prefix
          end

          # @return [void]
          def add_metadata_source_accessor!
            class_eval <<~RUBY, __FILE__, __LINE__ + 1
            # @return [String]
            def to_#{metadata_format_name}
              metadata_source
            end
            RUBY
          end
        end
      end
    end
  end
end
