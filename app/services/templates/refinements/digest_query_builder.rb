# frozen_string_literal: true

module Templates
  module Refinements
    # @api private
    module DigestQueryBuilder
      refine ::TemplateInstance::ClassMethods do
        def digest_build_query(for_derived: false)
          li = template_record.layout_instance_table

          projections = [
            arel_table[:id].as("template_instance_id"),
            arel_quote(template_record.instance_type).as("template_instance_type"),
            arel_table[:template_definition_id],
            arel_quote(template_record.definition_type).as("template_definition_type"),
            arel_table[:layout_instance_id],
            arel_quote(template_record.layout_instance_type).as("layout_instance_type"),
            li[:layout_definition_id],
            arel_quote(template_record.layout_definition_type).as("layout_definition_type"),
            arel_table[:entity_id],
            arel_table[:entity_type],
            arel_table[:position],
            arel_table[:layout_kind],
            arel_table[:template_kind],
            digest_build_width.as("width"),
            arel_table[:generation],
            arel_table[:config],
            digest_build_slots.as("slots"),
            arel_table[:render_duration],
            arel_table[:last_rendered_at]
          ]

          if for_derived
            projections << arel_table[:created_at] << arel_table[:updated_at]
          end

          unscoped.select(*projections).joins(:layout_instance).joins(:template_definition)
        end

        private

        def digest_build_slots
          slots = arel_table[:slots]

          with_kind = arel_named_fn("jsonb_build_object", "template_kind", arel_table[:template_kind])

          arel_infix("||", slots, with_kind)
        end

        def digest_build_width
          if template_record.has_width?
            template_record.definition_table[:width]
          else
            arel_cast(arel_quote(nil), "template_width")
          end
        end
      end
    end
  end
end
