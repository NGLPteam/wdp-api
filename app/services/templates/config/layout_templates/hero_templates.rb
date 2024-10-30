# frozen_string_literal: true

module Templates
  module Config
    module LayoutTemplates
      # @see Layouts::HeroDefinition
      # @see Templates::Config::Layout::Hero
      class HeroTemplates < ::Templates::Config::Utility::PolymorphicTemplateMapper
        configures_templates_for_layout! :hero
      end
    end
  end
end
