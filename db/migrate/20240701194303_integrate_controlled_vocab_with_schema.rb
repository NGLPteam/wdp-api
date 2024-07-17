# frozen_string_literal: true

class IntegrateControlledVocabWithSchema < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL
        ALTER TYPE "public"."schema_property_type" ADD VALUE IF NOT EXISTS 'controlled_vocabulary' AFTER 'contributors';
        ALTER TYPE "public"."schema_property_type" ADD VALUE IF NOT EXISTS 'controlled_vocabularies' AFTER 'controlled_vocabulary';
        SQL
      end
    end
  end
end
