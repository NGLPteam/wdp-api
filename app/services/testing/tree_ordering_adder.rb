# frozen_string_literal: true

module Testing
  # @api private
  class TreeOrderingAdder
    include Dry::Monads[:do, :result]
    include MonadicPersistence
    include Dry::Initializer[undefined: false].define -> do
      option :id, Dry::Types["coercible.string"], default: proc { "test_tree" }
      option :name, Dry::Types["coercible.string"], default: proc { "Test Tree" }
      option :position, Dry::Types["coercible.integer"].constrained(gt: 0), default: proc { 10_000 }
    end

    # @param [SchemaInstance] entity
    # @return [Ordering]
    def call(entity)
      ordering = entity.orderings.by_identifier(id).first_or_initialize do |ord|
        ord.schema_version = entity.schema_version
      end

      ordering.definition = build_definition

      ordering.schema_position = position
      ordering.position = position

      monadic_save ordering
    end

    private

    def build_definition
      PropertyHash.new.tap do |d|
        d["id"] = id
        d["name"] = name
        d["render.mode"] = "tree"
        d["select.direct"] = "descendants"
        d["order"] = [
          { "path" => "entity.title", "direction" => "asc" }
        ]
        d["hidden"] = true
        d["position"] = position
      end.to_h
    end
  end
end
