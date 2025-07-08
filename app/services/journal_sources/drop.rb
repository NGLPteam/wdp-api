# frozen_string_literal: true

module JournalSources
  class Drop < ::Liquid::Drop
    include Dry::Matcher.for(:match_journal_source, with: ::JournalSources::Matcher)

    # @param [JournalSources::Parsed::Abstract] journal_source
    def initialize(journal_source = nil)
      @journal_source = journal_source

      @exists = @journal_source.try(:known?).present?

      match_journal_source do |m|
        m.full do |parsed|
          @volume = parsed.volume
          @issue = parsed.issue
        end

        m.volume_only do |parsed|
          @volume = parsed.volume
          @issue = nil
        end

        m.unknown do
          @volume = @issue = nil
        end
      end
    end

    # @return [Boolean]
    attr_reader :exists

    # @return [String, nil]
    attr_reader :issue

    # @return [String, nil]
    attr_reader :volume

    private

    def match_journal_source
      @journal_source
    end
  end
end
