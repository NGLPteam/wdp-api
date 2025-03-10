# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      # @abstract
      class Abstract < Shale::Mapper
        extend ActiveModel::Callbacks
        extend Dry::Core::ClassAttributes

        include Dry::Core::Constants
        include Dry::Core::Memoizable

        include Dry::Effects::Handler.Reader(:render_context)
        include Dry::Effects::Handler.State(:render_data)
        include Dry::Effects.State(:render_data)

        defines :render_configs, type: Harvesting::Extraction::RenderConfig::Map

        defines :renderable_attributes, type: Harvesting::Extraction::Types::SymbolList

        render_configs EMPTY_HASH

        renderable_attributes EMPTY_ARRAY

        define_model_callbacks :render

        def call_operation(name, *args, **kwargs)
          MeruAPI::Container[name].call(*args, **kwargs)
        end

        def call_operation!(...)
          call_operation(...).value!
        end

        # @return [Liquid::Environment]
        def environment
          @environment ||= build_environment
        end

        # @abstract
        # @return [{ Symbol => Object }]
        def environment_options
          {}
        end

        # @param [Harvesting::Extraction::RenderContext] render_context
        # @return [Dry::Monads::Success{ Symbol => Dry::Monads::Result }]
        def rendered_attributes_for(render_context)
          self.class.renderable_attributes.index_with do |attribute_name|
            _liquid_render_for attribute_name, render_context
          end
        end

        private

        def build_environment
          options = environment_options.deep_symbolize_keys

          call_operation!("harvesting.extraction.build_environment", **options)
        end

        def build_liquid_template_for(raw_template_source)
          Liquid::Template.parse(raw_template_source.to_s, environment:, line_numbers: false)
        end

        memoize def _liquid_template_for(attribute_name)
          source = __send__(attribute_name)

          return nil if source.nil?

          build_liquid_template_for source
        end

        def _liquid_render_for(attribute_name, render_context)
          config = self.class.render_configs.fetch(attribute_name.to_sym)

          output = nil

          errors = []

          template = _liquid_template_for(attribute_name)

          if template.nil?
            return RenderResult.new(config:, output: nil, errors:, data: EMPTY_HASH, no_template: true).to_monad
          end

          data = _wrap_liquid_render_for(attribute_name, render_context) do
            output = template.render(render_context.assigns, strict_filters: true, strict_variables: true)

            template.errors.each do |error|
              errors << Harvesting::Extraction::Error.from(error)
            end
          end
        rescue Liquid::Error => e
          errors << Harvesting::Extraction::Error.from(e)

          RenderResult.new(config:, output: nil, errors:, data: EMPTY_HASH).to_monad
        else
          RenderResult.new(config:, output:, errors:, data:).to_monad
        end

        # @return [Hash] captures and returns the render data
        def _wrap_liquid_render_for(attribute_name, render_context)
          data, _ = with_render_data({}.with_indifferent_access) do
            with_render_context render_context do
              run_callbacks :render do
                run_callbacks :"render_#{attribute_name}" do
                  yield
                end
              end
            end
          end

          return data
        end

        class << self
          def render_attr!(name, raw_type = Dry::Types::Any, data: false, &finesser)
            type = Harvesting::Metadata::Types.registered_type_for raw_type

            options = {
              name:,
              type:,
              data:,
            }

            options[:finesser] = finesser if block_given?

            render_config = Harvesting::Extraction::RenderConfig.new(**options)

            define_model_callbacks render_config.callback_name

            new_configs = render_configs.merge(render_config.name => render_config)

            render_configs new_configs

            renderable_attributes render_configs.keys
          end

          # @param [<Symbol>] names
          # @return [void]
          def renderable!(*names)
            names.flatten.each do |name|
              render_attr! name
            end
          end
        end
      end
    end
  end
end
