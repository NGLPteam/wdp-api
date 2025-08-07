# frozen_string_literal: true

# We rely on a gem that defines `object_id` in their serialized mappers.
# Whether or not this is advised, it is outside of our control and the
# warning is not helpful.

module Patches
  module SilenceLutamlModelAttributeWarnings
    def warn_name_conflict(...); end
  end

  module SilenceLutamlModelSerializeWarnings
    def define_attribute_methods(attr)
      Kernel.silence_warnings do
        super
      end
    end
  end
end

Lutaml::Model::Attribute.prepend Patches::SilenceLutamlModelAttributeWarnings
Lutaml::Model::Serialize::ClassMethods.prepend Patches::SilenceLutamlModelSerializeWarnings
