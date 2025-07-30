# frozen_string_literal: true

RSpec.describe Schemas::Instances::RefreshOrderings, type: :operation do
  let_it_be(:community) do
    FactoryBot.create :community
  end

  let_it_be(:journal) do
    FactoryBot.create :collection, schema: "nglp:journal", community:
  end

  let_it_be(:volume) do
    FactoryBot.create :collection, schema: "nglp:journal_volume", parent: journal
  end

  let_it_be(:issue) do
    FactoryBot.create :collection, schema: "nglp:journal_issue", parent: volume
  end

  let_it_be(:article) do
    FactoryBot.create :item, schema: "nglp:journal_article", collection: issue
  end

  let(:issue_orderings_count) { 4 }
  let(:article_orderings_count) { 4 }

  let!(:refresh_ordering) { TestHelpers::TestOperation.new }

  before do
    allow(refresh_ordering).to receive(:call).and_call_original
  end

  let(:operation) do
    described_class.new(refresh: refresh_ordering)
  end

  context "when refreshing an issue" do
    context "when synchronous" do
      it "only refreshes the right number of orderings" do
        expect do
          expect_calling_with(issue)
        end.to keep_the_same(OrderingInvalidation, :count)

        expect(refresh_ordering).to have_received(:call).exactly(issue_orderings_count).times
      end
    end
  end

  context "when refreshing an article" do
    context "when synchronous" do
      it "only refreshes the right number of orderings" do
        expect do
          expect_calling_with(article).to succeed
        end.to keep_the_same(OrderingInvalidation, :count)

        expect(refresh_ordering).to have_received(:call).exactly(article_orderings_count).times
      end
    end

    context "when async" do
      around do |example|
        Schemas::Orderings.with_asynchronous_refresh do
          example.run
        end
      end

      it "enqueues the right number of jobs" do
        expect do
          expect_calling_with(article).to succeed
        end.to change(OrderingInvalidation, :count).by(article_orderings_count)

        expect(refresh_ordering).not_to have_received(:call)
      end
    end

    context "when deferred" do
      it "defers enqueuing the right number of jobs until the block exits" do
        expect do
          Schemas::Orderings.with_deferred_refresh do
            expect_calling_with(article).to succeed
          end
        end.to change(OrderingInvalidation, :count).by(article_orderings_count)

        expect(refresh_ordering).not_to have_received(:call)
      end
    end
  end
end
