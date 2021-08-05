# frozen_string_literal: true

module Links
  # Validate the inputs for a call to {Links::Connect}.
  class ValidateConnection < ApplicationContract
    schema do
      required(:source).value(Links::Types.Instance(ApplicationRecord))
      required(:target).value(Links::Types.Instance(ApplicationRecord))
      required(:operator).value(Links::Types::Operator)
    end

    rule(:source).validate(:entity)
    rule(:target).validate(:entity)

    rule(:source, :target) do
      next unless values[:source].kind_of?(HierarchicalEntity) && values[:target].kind_of?(HierarchicalEntity)

      if values[:source].contextual_parent == values[:target]
        key(:source).failure(:linked_to_parent)
      elsif values[:target].contextual_parent == values[:source]
        key(:target).failure(:linked_to_parent)
      elsif values[:source] == values[:target]
        key(:source).failure(:linked_to_itself)
      end
    end
  end
end
