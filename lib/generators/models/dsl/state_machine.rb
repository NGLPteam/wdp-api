# frozen_string_literal: true

module DSL
  class StateMachine
    attr_reader :states, :model

    delegate :schema, to: :model

    def initialize(model, states)
      @model = model
      @states = states
    end

    def prev_state(state)
      index = states.index(state)
      return nil unless index || index == 0

      states[index - 1] || nil
    end

    def next_state(state)
      index = states.index(state)
      return nil unless index

      states[index + 1] || nil
    end

    def initial?(state)
      states.index(state) == 0
    end

    def model_name
      "#{@model.table_name}_transition"
    end

    def transition_model
      ref = model.key
      parent_model_name = model.singular_name
      model_name = "#{model.singular_name}_transition"
      index_name = "#{model.singular_name}_state_index"
      @transition_model ||= begin
        transition_model = Model.new(schema, model_name, tenant: model.tenant_model?, slug: :none) do
          description "A #{parent_model_name} state machine transition"
          r ref, on_delete: :cascade, index: { name: index_name }
          a :most_recent, :default_false
          a :sort_key, :integer
          a :to_state, :string
          a :metadata, :jsonb
        end
        schema.register_model transition_model
        transition_model
      end
    end

    def tenant?
      tenant
    end
  end
end
