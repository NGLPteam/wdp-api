# frozen_string_literal: true

# A collection of built-in {Role roles} that an end-user cannot modify.
class SystemRole < FrozenRecord::Base
  include Dry::Core::Memoizable
  include FrozenArel
  include FrozenSchema
  include TranslatedFrozenRecord

  schema! do
    required(:identifier).filled(:string)
    required(:name).filled(:string)
    required(:access_control_list).value(Roles::Types::ACL)
    required(:global_access_control_list).value(Roles::Types::GACL)
  end

  default_sql_values [:identifier, :name, :acl, :gacl]

  self.primary_key = :identifier

  add_index :identifier, unique: true

  alias_attribute :acl, :access_control_list

  alias_attribute :gacl, :global_access_control_list

  def allowed_actions
    acl.allowed_actions
  end

  def global_allowed_actions
    gacl.allowed_actions
  end

  def to_sql_value(key)
    case key
    when :access_control_list, :acl
      arel_quote_grid acl
    when :global_access_control_list, :gacl
      arel_quote_grid gacl
    when :system_slug
      arel_quote identifier
    else
      super
    end
  end

  private

  def arel_quote_grid(value)
    arel_quote value.to_json
  end
end
