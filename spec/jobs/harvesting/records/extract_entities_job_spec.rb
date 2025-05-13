# frozen_string_literal: true

RSpec.describe Harvesting::Records::ExtractEntitiesJob, type: :job do
  context "with a valid JATS record" do
    let_it_be(:target_entity, refind: true) { FactoryBot.create :collection, :journal }

    let_it_be(:harvest_source, refind: true) { FactoryBot.create :harvest_source, :oai, :jats }

    let_it_be(:harvest_configuration, refind: true) { harvest_source.create_configuration!(target_entity:) }

    let_it_be(:sample_record) { Harvesting::Testing::OAI::JATSRecord.find("1576") }

    let_it_be(:harvest_record, refind: true) do
      FactoryBot.create(
        :harvest_record,
        :pending,
        harvest_source:,
        harvest_configuration:,
        sample_record:
      )
    end

    it "can extract harvest entities" do
      expect do
        described_class.perform_now harvest_record
      end.to have_enqueued_job(Harvesting::Records::UpsertEntitiesJob).once
        .and change { harvest_record.reload.status }.from("pending").to("active")
        .and change { harvest_record.reload.entity_count }.from(nil).to(3)
        .and change(HarvestEntity, :count).by(3)
        .and change(HarvestContribution, :count).by(1)
        .and change(HarvestContributor, :count).by(1)
        .and change(Contributor, :count).by(1)
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
        :pending,
        harvest_source:,
        harvest_configuration:,
        sample_record:
      )
    end

    it "extracts the record with the right metadata-mapped parent" do
      expect do
        described_class.perform_now harvest_record
      end.to have_enqueued_job(Harvesting::Records::UpsertEntitiesJob).once
        .and change { harvest_record.reload.status }.from("pending").to("active")
        .and change { harvest_record.reload.entity_count }.from(nil).to(1)
        .and change(HarvestEntity.where(existing_parent: uiowa_ofm), :count).by(1)
        .and change(HarvestContribution, :count).by(4)
        .and change(HarvestContributor, :count).by(4)
        .and change(Contributor, :count).by(4)
    end

    context "when there are conflicts in the metadata mapping" do
      let_it_be(:conflicting_mapping) do
        harvest_source.assign_metadata_mapping!(field: :title, pattern: "^Bedrock Geologic Map", target_entity: uiowa_iwp)
      end

      it "fails to extract the record" do
        expect do
          described_class.perform_now harvest_record
        end.to keep_the_same(HarvestEntity, :count)
          .and have_enqueued_no_jobs(Harvesting::Records::UpsertEntitiesJob)
          .and change { harvest_record.reload.status }.from("pending").to("skipped")
          .and change { harvest_record.reload.entity_count }.from(nil).to(0)
          .and change { harvest_record.skipped.try(:code) }.from(nil).to("metadata_mapping_too_many_found")
          .and change { harvest_record.skipped.try(:reason) }.from(nil).to("too many metadata mappings match")
          .and change(HarvestMessage.error.where(harvest_record:).where_begins_like(message: "Too many metadata"), :count).by(1)
      end
    end

    context "when there is no matching metadata mapping" do
      before do
        HarvestMetadataMapping.where(target_entity: uiowa_ofm).destroy_all
      end

      it "fails to extract the record" do
        expect do
          described_class.perform_now harvest_record
        end.to keep_the_same(HarvestEntity, :count)
          .and have_enqueued_no_jobs(Harvesting::Records::UpsertEntitiesJob)
          .and change { harvest_record.reload.status }.from("pending").to("skipped")
          .and change { harvest_record.reload.entity_count }.from(nil).to(0)
          .and change { harvest_record.skipped.try(:code) }.from(nil).to("metadata_mapping_not_found")
          .and change { harvest_record.skipped.try(:reason) }.from(nil).to("no metadata mappings found")
          .and change(HarvestMessage.error.where(harvest_record:).where_begins_like(message: "Could not find metadata mapping with"), :count).by(1)
      end
    end
  end
end
