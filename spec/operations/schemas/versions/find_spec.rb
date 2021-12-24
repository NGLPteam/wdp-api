# frozen_string_literal: true

RSpec.describe Schemas::Versions::Find, type: :operation do
  let(:operation) { described_class.new }

  shared_context "with schema definition" do
    let!(:schema_definition) { FactoryBot.create :schema_definition, :for_item }

    shared_context "with schema versions" do
      let!(:version_2) { FactoryBot.create :schema_version, :item, number: "2.0.0", schema_definition: schema_definition }
      let!(:version_1) { FactoryBot.create :schema_version, :item, number: "1.0.0", schema_definition: schema_definition }
    end
  end

  context "when calling with a declaration" do
    it "fails with valid but non-existent declarations" do
      aggregate_failures do
        expect_calling_with("valid.identifier").to monad_fail.with_key(:not_found), "a lax schema declaration"
        expect_calling_with("valid.identifier:latest").to monad_fail.with_key(:not_found), "a lax latest version declaration"
        expect_calling_with("valid.identifier:1.2.3").to monad_fail.with_key(:not_found), "a lax versioned schema declaration"
        expect_calling_with("valid:identifier").to monad_fail.with_key(:not_found), "a strict schema declaration"
        expect_calling_with("valid:identifier:latest").to monad_fail.with_key(:not_found), "a strict latest version declaration"
        expect_calling_with("valid:identifier:xxx1.2.3").to monad_fail.with_key(:invalid), "a strict versioned schema declaration"
      end
    end
  end

  context "when calling with a model id" do
    context "with a schema definition" do
      include_context "with schema definition"

      context "with multiple versions" do
        include_context "with schema versions"

        it "finds the latest version" do
          expect_calling_with(schema_definition.id).to succeed.with(version_2)
        end
      end

      context "with no defined versions" do
        it "fails to find the latest" do
          expect_calling_with(schema_definition.id).to monad_fail.with_key(:no_versions)
        end
      end
    end

    context "with a schema version" do
      let!(:schema_version) { FactoryBot.create :schema_version, :item }

      it "finds the correct version" do
        expect_calling_with(schema_version.id).to succeed.with(schema_version)
      end
    end

    context "with another model id" do
      let!(:user) { FactoryBot.create :user }

      it "fails to find a version" do
        expect_calling_with(user.id).to monad_fail.with_key(:not_found)
      end
    end
  end

  context "when calling with a schema version" do
    let!(:schema_version) { FactoryBot.create :schema_version, :item }
    let!(:other_version) { FactoryBot.create :schema_version, :item }

    it "finds the correct version" do
      expect_calling_with(schema_version).to succeed.with(schema_version)
    end
  end

  context "when calling with a schema definition" do
    include_context "with schema definition"

    context "with no defined versions" do
      it "fails to find the latest version with the instance" do
        expect_calling_with(schema_definition).to monad_fail.with_key(:no_versions)
      end
    end

    context "with versions" do
      include_context "with schema versions"

      it "finds the latest version with the instance" do
        expect_calling_with(schema_definition).to succeed.with(version_2)
      end
    end
  end
end
