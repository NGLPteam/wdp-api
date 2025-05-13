# frozen_string_literal: true

RSpec.describe PilotHarvesting::Root do
  context "with a completely fresh set" do
    let_it_be(:base_url) { Harvesting::Testing::ProviderDefinition.oai.first.oai_endpoint }
    let_it_be(:communities) do
      [
        {
          seed_identifier: "some-test",
          identifier: "ph-test",
          title: "Pilot Harvesting Test Community",
          journals: [
            {
              identifier: "ph-test-journal",
              title: "Pilot Harvesting Test Journal",
              metadata_format: "jats",
              skip_harvest: false,
              url: base_url,
            }
          ],
          series: [
            {
              identifier: "ph-test-series",
              title: "Pilot Harvesting Test Series",
              metadata_format: "oaidc",
              skip_harvest: false,
              url: base_url,
            }
          ],
          use_metadata_mappings: true,
          metadata_mappings: [
            { identifier: "will-not-exist", field: "title", pattern: "foo-bar-baz.+", }
          ],
        },
      ]
    end

    let_it_be(:root) do
      described_class.new(communities:)
    end

    describe "#call" do
      it "creates the hierarchy, starts the harvest, and ignores the invalid metadata mappings" do
        expect do
          expect(root.call).to succeed
        end.to change(Community, :count).by(1)
          .and change(Collection.filtered_by_schema_version("nglp:journal"), :count).by(1)
          .and change(Collection.filtered_by_schema_version("nglp:series"), :count).by(1)
          .and change(HarvestSource, :count).by(2)
          .and change(HarvestMapping, :count).by(2)
          .and keep_the_same(HarvestSet, :count)
          .and keep_the_same(HarvestMetadataMapping, :count)
          .and change(HarvestAttempt, :count).by(2)
          .and have_enqueued_job(Harvesting::Sources::ExtractSetsJob).twice
      end
    end
  end

  context "when dealing with metadata mappings" do
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

    let_it_be(:base_url) { Harvesting::Testing::ProviderDefinition.oai.first.oai_endpoint }

    let_it_be(:communities) do
      [
        {
          "seed_identifier" => "btaa-uiowa-esploro",
          "identifier" => "uiowa",
          "title" => "University of Iowa",
          "url" => base_url,
          "set_identifier" => "iro:meru-esploro",
          "metadata_format" => "esploro",
          "skip_harvest" => true,
          "use_metadata_mappings" => true,
          "metadata_mappings" => [
            { "identifier" => "uiowa-ofm", "field" => "relation", "pattern" => "^ispartof:[[:space:]]+Open file map series.*" },
            { "identifier" => "uiowa-wrir", "field" => "relation", "pattern" => "^ispartof:[[:space:]]+Water Resources Investigation Report.*" },
            { "identifier" => "uiowa-tech-info-series", "field" => "relation", "pattern" => "^ispartof:[[:space:]]+Technical Information Series.*" },
            { "identifier" => "uiowa-tech-info-series", "field" => "relation", "pattern" => "^ispartof:[[:space:]]+Iowa Geological Survey Technical Information Series.*" },
            { "identifier" => "uiowa-wsb", "field" => "relation", "pattern" => "^ispartof:[[:space:]]+Water-supply bulletin.*" },
            { "identifier" => "uiowa-iihr-monographs", "field" => "identifier", "pattern" => "^iihr_monograph_series.*" },
            { "identifier" => "uiowa-iwp", "field" => "title", "pattern" => "^International Writing Program.*" },
            { "identifier" => "uiowa-iwpar", "field" => "title", "pattern" => "^The International Writing Program at the University of Iowa annual report.*" }
          ],
        }
      ]
    end

    let_it_be(:root) do
      described_class.new(communities:)
    end

    describe "#call" do
      it "creates a whole slew of necessary harvesting materials" do
        expect do
          expect(root.call).to succeed
        end.to keep_the_same(Community, :count)
          .and keep_the_same(Collection, :count)
          .and change(HarvestSource, :count).by(1)
          .and change(HarvestMapping, :count).by(1)
          .and change(HarvestSet, :count).by(1)
          .and change(HarvestAttempt, :count).by(1)
          .and change(HarvestMetadataMapping, :count).by(8)
          .and have_enqueued_job(Harvesting::Sources::ExtractSetsJob).once
      end
    end
  end
end
