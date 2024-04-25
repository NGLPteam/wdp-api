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

  let(:issue_orderings_count) { 3 }
  let(:article_orderings_count) { 3 }

  let!(:refresh_ordering) { TestHelpers::TestOperation.new }
  let!(:calculate_initial) { TestHelpers::TestOperation.new }

  before do
    allow(refresh_ordering).to receive(:call).and_call_original
    allow(calculate_initial).to receive(:call).and_call_original
  end

  let(:operation) do
    described_class.new refresh: refresh_ordering, calculate_initial:
  end

  context "when refreshing an issue" do
    context "when synchronous" do
      it "only refreshes the right number of orderings" do
        expect do
          expect_calling_with(issue)
        end.not_to have_enqueued_job(Schemas::Orderings::RefreshJob)

        expect(refresh_ordering).to have_received(:call).exactly(issue_orderings_count).times
        expect(calculate_initial).to have_received(:call).once
      end
    end
  end

  context "when refreshing an article" do
    context "when synchronous" do
      it "only refreshes the right number of orderings" do
        expect do
          expect_calling_with(article).to succeed
        end.not_to have_enqueued_job(Schemas::Orderings::RefreshJob)

        expect(refresh_ordering).to have_received(:call).exactly(article_orderings_count).times
        expect(calculate_initial).not_to have_received(:call)
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
        end.to have_enqueued_job(Schemas::Orderings::RefreshJob).exactly(article_orderings_count).times

        expect(refresh_ordering).not_to have_received(:call)
        expect(calculate_initial).not_to have_received(:call)
      end
    end

    context "when deferred" do
      it "defers enqueuing the right number of jobs until the block exits" do
        expect do
          Schemas::Orderings.with_deferred_refresh do
            expect do
              expect_calling_with(article).to succeed
            end.not_to have_enqueued_job(Schemas::Orderings::RefreshJob)
          end

          # This is necessary because of how dry-effects and rspec interact
          sleep 0.1

          # now the block has exited so we can have the jobs be enqueued
          expect do
            operation.refresh_status
          end.to raise_error Dry::Effects::Errors::UnhandledEffectError
        end.to have_enqueued_job(Schemas::Orderings::RefreshJob).exactly(article_orderings_count).times

        expect(refresh_ordering).not_to have_received(:call)
        expect(calculate_initial).not_to have_received(:call)
      end
    end
  end
end
