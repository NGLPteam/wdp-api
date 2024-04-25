# frozen_string_literal: true

module DSL
  module WithMigrationOptions
    MIGRATION_ALLOWED_OPTIONS = [:foreign_key, :polymorphic, :type, :index, :null, :comment, :collation, :default, :precision, :scale, :if_not_exists].freeze

    def options_for_migration
      options.slice(*MIGRATION_ALLOWED_OPTIONS).tap do |migration_options|
        migration_options[:polymorphic] = true if migration_options.key?(:polymorphic)
        migration_options.delete :foreign_key if tenant_foreign_key?
      end
    end

    def tenant_foreign_key?
      false
    end

    def stringify_value(v)
      if v.is_a? Hash
        out = v.to_s.gsub(/(:(\w+)\s?=>\s?)/, "\\2: ")
        return out.sub("{", "{ ").sub("}", " }")
      end

      v.inspect
    end

    def inject_options
      (+"").tap { |s| options_for_migration.each { |k, v| s << ", #{k}: #{stringify_value(v)}" } }
    end
  end
end
