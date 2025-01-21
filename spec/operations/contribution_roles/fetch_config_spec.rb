# frozen_string_literal: true

RSpec.describe ContributionRoles::FetchConfig, type: :operation do
  let_it_be(:global_configuration) { GlobalConfiguration.fetch }
  let_it_be(:global_contribution_role_configuration) { global_configuration.contribution_role_configuration }

  let_it_be(:specific_vocabulary) { FactoryBot.create :controlled_vocabulary }
  let_it_be(:specific_item) { FactoryBot.create :controlled_vocabulary_item, controlled_vocabulary: specific_vocabulary }

  let_it_be(:community, refind: true) { FactoryBot.create :community }

  let_it_be(:collection, refind: true) { FactoryBot.create :collection, community: }

  let_it_be(:item, refind: true) { FactoryBot.create :item, collection: }

  def give_specific_configuration!(record)
    config = record.build_contribution_role_configuration

    config.controlled_vocabulary = specific_vocabulary
    config.default_item = specific_item
    config.save!
  end

  context "when fetching with no specifier" do
    it "reads from global configuration by default" do
      expect_calling.to succeed.with(global_contribution_role_configuration)
    end
  end

  context "when fetching a configuration for an item" do
    it "reads from global configuration by default" do
      expect_calling_with(contributable: item).to succeed.with(global_contribution_role_configuration)
    end

    context "when its community has an override" do
      before do
        give_specific_configuration!(community)

        item.reload
      end

      it "will inherit the decision" do
        expect_calling_with(contributable: item).to succeed.with(community.reload_contribution_role_configuration)
      end
    end

    context "when its schema version has an override" do
      let_it_be(:item_schema, refind: true) { item.schema_version }

      before do
        give_specific_configuration!(item_schema)

        item.reload
      end

      it "will inherit the decision" do
        expect_calling_with(contributable: item).to succeed.with(item_schema.reload_contribution_role_configuration)
      end
    end
  end
end
