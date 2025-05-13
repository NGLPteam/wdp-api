# frozen_string_literal: true

RSpec.describe Harvesting::Records::UpsertEntitiesJob, type: :job do
  include ActiveJob::TestHelper

  def actual_entity_for(identifier)
    harvest_record.harvest_entities.where(identifier:).first!.reload_entity
  end

  context "with a valid JATS record" do
    let_it_be(:target_entity, refind: true) { FactoryBot.create :collection, :journal }

    let_it_be(:harvest_source, refind: true) { FactoryBot.create :harvest_source, :oai, :jats }

    let_it_be(:harvest_configuration, refind: true) { harvest_source.create_configuration!(target_entity:) }

    let_it_be(:sample_record) { Harvesting::Testing::OAI::JATSRecord.find("1576") }

    let_it_be(:harvest_record, refind: true) do
      FactoryBot.create(
        :harvest_record,
        harvest_source:,
        harvest_configuration:,
        sample_record:
      )
    end

    before do
      harvest_record.extract_entities!
    end

    it "can upsert entities from extracted harvest entities, and then upsert assets in a separate asynchronous job" do
      expect do
        described_class.perform_now harvest_record
      end.to change(Collection, :count).by(2)
        .and change(Item, :count).by(1)
        .and change(ItemContribution, :count).by(1)
        .and have_enqueued_job(Harvesting::Entities::UpsertAssetsJob).once

      # test extracted entity content
      volume = actual_entity_for("volume-1")
      issue = actual_entity_for("issue-1")
      article = actual_entity_for("meru:oai:jats:1576")

      aggregate_failures do
        expect(volume).to have_schema_version("nglp:journal_volume")
        expect(issue).to have_schema_version("nglp:journal_issue")
        expect(article).to have_schema_version("nglp:journal_article")
        expect(article.published).to eq VariablePrecisionDate.parse("2018-11-03")
        expect(article.doi).to eq "10.36021/jethe.v1i1.14.g5"
        expect(article.read_property_value!("abstract")).to include_json(
          lang: "en",
          kind: "html",
          content: match(/\A<p>Handwriting is a multisensory process/)
        )
      end

      # We'll also test entity asset upsertion here because it's more effort than it's worth
      # to set up the job tests separately given that we have to repeat everything done here.
      expect do
        perform_enqueued_jobs
      end.to change(Asset.pdf, :count).by(1)
        .and change { article.reload.read_property_value!("pdf_version") }.from(nil).to(a_kind_of(::Asset))
    end
  end

  context "with a valid esploro record with metadata mappings" do
    let_it_be(:uiowa, refind: true) { FactoryBot.create :community, identifier: "uiowa" }

    let_it_be(:uiowa_iihr_monographs, refind: true) do
      FactoryBot.create(:collection, :series, community: uiowa, identifier: "uiowa-iihr-monographs", title: "IIHR Monographs")
    end

    let_it_be(:uiowa_iwp, refind: true) do
      FactoryBot.create(:collection, :series, community: uiowa, identifier: "uiowa-iwp", title: "International Writing Program")
    end

    let_it_be(:uiowa_iwpar, refind: true) do
      FactoryBot.create(:collection, :series, community: uiowa, identifier: "uiowa-iwpar", title: "International Writing Program Annual Report")
    end

    let_it_be(:uiowa_ofm, refind: true) do
      FactoryBot.create(:collection, :series, community: uiowa, identifier: "uiowa-ofm", title: "Open File Maps")
    end

    let_it_be(:uiowa_tech_info_series, refind: true) do
      FactoryBot.create(:collection, :series, community: uiowa, identifier: "uiowa-tech-info-series", title: "Technical Information Series")
    end

    let_it_be(:uiowa_wrir, refind: true) do
      FactoryBot.create(:collection, :series, community: uiowa, identifier: "uiowa-wrir", title: "Water Resources Investigation Report")
    end

    let_it_be(:uiowa_wsb, refind: true) do
      FactoryBot.create(:collection, :series, community: uiowa, identifier: "uiowa-wsb", title: "Water-Supply Bulletin")
    end

    let_it_be(:target_entity, refind: true) { uiowa }

    let_it_be(:harvest_source, refind: true) { FactoryBot.create :harvest_source, :oai, :esploro, :using_metadata_mappings }

    let_it_be(:harvest_configuration, refind: true) { harvest_source.create_configuration!(target_entity:) }

    let_it_be(:metadata_mapping_definitions) do
      [
        { "identifier" => "uiowa-ofm", "field" => "relation", "pattern" => "^ispartof:[[:space:]]+Open file map series.*" },
        { "identifier" => "uiowa-wrir", "field" => "relation", "pattern" => "^ispartof:[[:space:]]+Water Resources Investigation Report.*" },
        { "identifier" => "uiowa-tech-info-series", "field" => "relation", "pattern" => "^ispartof:[[:space:]]+Technical Information Series.*" },
        { "identifier" => "uiowa-tech-info-series", "field" => "relation", "pattern" => "^ispartof:[[:space:]]+Iowa Geological Survey Technical Information Series.*" },
        { "identifier" => "uiowa-wsb", "field" => "relation", "pattern" => "^ispartof:[[:space:]]+Water-supply bulletin.*" },
        { "identifier" => "uiowa-iihr-monographs", "field" => "identifier", "pattern" => "^iihr_monograph_series.*" },
        { "identifier" => "uiowa-iwp", "field" => "title", "pattern" => "^International Writing Program.*" },
        { "identifier" => "uiowa-iwpar", "field" => "title", "pattern" => "^The International Writing Program at the University of Iowa annual report.*" }
      ]
    end

    let_it_be(:metadata_mappings) do
      harvest_source.assign_metadata_mappings!(metadata_mapping_definitions, base_entity: target_entity)
    end

    let_it_be(:sample_record) { Harvesting::Testing::OAI::EsploroRecord.find("11811152460002771") }

    let_it_be(:harvest_record, refind: true) do
      FactoryBot.create(
        :harvest_record,
        harvest_source:,
        harvest_configuration:,
        sample_record:
      )
    end

    before do
      harvest_record.extract_entities!
    end

    it "extracts the record to the right metadata-mapped parent" do
      expect do
        described_class.perform_now harvest_record
      end.to keep_the_same(Collection, :count)
        .and change(Item, :count).by(1)
        .and change(ItemContribution, :count).by(4)
        .and have_enqueued_job(Harvesting::Entities::UpsertAssetsJob).once

      paper = actual_entity_for("meru:oai:esploro:11811152460002771")

      aggregate_failures do
        expect(paper).to have_schema_version("nglp:paper")
        expect(paper.collection).to eq uiowa_ofm
      end
    end
  end
end
