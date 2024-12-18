# frozen_string_literal: true

module Types
  # @see Template
  # @see Templates::Types::Kind
  class TemplateKindType < Types::BaseEnum
    description <<~TEXT
    Discriminator for the various types of templates available to an entity,
    based on its schema.
    TEXT

    value "HERO", value: "hero" do
      description <<~TEXT
      A template for describing how an entity's header / hero should look.

      Contained within the `HERO` layout.
      TEXT
    end

    value "LIST_ITEM", value: "list_item" do
      description <<~TEXT
      A template for describing how an entity should appear when rendered in a list.

      Contained within the `LIST_ITEM` layout.
      TEXT
    end

    value "BLURB", value: "blurb" do
      description <<~TEXT
      An arbitrary text blurb that can be used for describing citations or other
      runs of content that don't neatly fit within the prescribed hierarchies.

      Contained within the `MAIN` layout
      TEXT
    end

    value "DETAIL", value: "detail" do
      description <<~TEXT
      Describes details about an entity, its summary, etc.

      Contained within the `MAIN` layout.
      TEXT
    end

    value "DESCENDANT_LIST", value: "descendant_list" do
      description <<~TEXT
      A template for rendering descendants of an entity on its main layout,
      e.g. a journal listing some recent issues or a series listing featured papers.

      Contained within the `MAIN` layout.
      TEXT
    end

    value "LINK_LIST", value: "link_list" do
      description <<~TEXT
      A template for listing entity links on the main layout of an entity.

      Contained within the `MAIN` layout.
      TEXT
    end

    value "PAGE_LIST", value: "page_list" do
      description <<~TEXT
      A template for listing pages on the main layout of an entity.

      Contained within the `MAIN` layout.
      TEXT
    end

    value "CONTRIBUTOR_LIST", value: "contributor_list" do
      description <<~TEXT
      A template for listing contributors of note on the main layout of an entity.

      Contained within the `MAIN` layout.
      TEXT
    end

    value "ORDERING", value: "ordering" do
      description <<~TEXT
      For applicable entities, allows navigating through specific orderings,
      e.g. going back and forth between articles in a specific issue.

      Contained within the `MAIN` layout.
      TEXT
    end

    value "NAVIGATION", value: "navigation" do
      description <<~TEXT
      This controls the various tabs available to an entity when rendering
      its `MAIN`, `METADATA`, `SUPPLEMENTARY` routes.

      Contained within the `NAVIGATION` layout.
      TEXT
    end

    value "METADATA", value: "metadata" do
      description <<~TEXT
      A template for describing how an entity's metadata should be displayed.

      Contained within the `METADATA` layout.
      TEXT
    end

    value "SUPPLEMENTARY", value: "supplementary" do
      description <<~TEXT
      A template for describing how an entity's supplementary pages (contributors, metrics)
      should render.

      Contained within the `SUPPLEMENTARY` layout.
      TEXT
    end
  end
end
