# frozen_string_literal: true

RSpec.shared_examples_for "a graphql entity with layouts" do
  let(:entity) { raise "entity must be set" }

  let(:slug) { entity.system_slug }

  let(:graphql_variables) do
    { slug:, }
  end

  let(:query_name) { "get#{entity.model_name}Layouts" }
  let(:field_name) { entity.model_name.i18n_key.to_s }

  let(:query) do
    <<~GRAPHQL
    query #{query_name}($slug: Slug!) {
      entity: #{field_name}(slug: $slug) {
        layouts {
          hero {
            lastRenderedAt
            template {
              layoutKind
              templateKind
              lastRenderedAt
              definition {
                id
              }

              slots {
                header {
                  content
                }

                headerAside {
                  content
                }

                headerSidebar {
                  content
                }

                headerSummary {
                  content
                }
              }
            }
          }

          listItem {
            lastRenderedAt
            template {
              layoutKind
              templateKind
              lastRenderedAt
              definition {
                id
              }
            }
          }

          navigation {
            lastRenderedAt
            template {
              layoutKind
              templateKind
              lastRenderedAt
              definition {
                id
              }
            }
          }

          metadata {
            lastRenderedAt
            template {
              layoutKind
              templateKind
              lastRenderedAt
              definition {
                id
              }
            }
          }

          supplementary {
            lastRenderedAt
            template {
              layoutKind
              templateKind
              lastRenderedAt
              definition {
                id
              }
            }
          }

          main {
            lastRenderedAt

            templates {
              __typename

              ... on TemplateInstance {
                layoutKind
                templateKind
                lastRenderedAt
              }
            }
          }
        }
      }
    }
    GRAPHQL
  end

  let(:expected_shape) do
    gql.query do |q|
      q.prop :entity do |ent|
        ent.prop :layouts do |lyts|
          Layout.pluck(:layout_kind).without("main").each do |kind|
            lyts.prop kind do |lyt|
              lyt[:last_rendered_at] = be_present

              lyt.prop :template do |tpl|
                tpl[:layout_kind] = kind.upcase
                tpl[:template_kind] = kind.upcase
                tpl[:last_rendered_at] = be_present
              end
            end
          end

          lyts.prop :main do |main|
            main[:last_rendered_at] = be_present

            main[:templates] = be_present
          end
        end
      end
    end
  end

  before do
    entity.render_layouts!
  end

  it "will fetch templates as desired" do
    expect_request! do |req|
      req.effect! execute_safely

      req.data! expected_shape
    end
  end
end
