# frozen_string_literal: true

module EsploroSchema
  module Common
    # @api private
    class PropertyDefinition
      include Dry::Core::Equalizer.new(:name)

      include Dry::Initializer[undefined: false].define -> do
        option :name, EsploroSchema::Types::Symbol

        option :raw_type, EsploroSchema::Types::MapperType

        option :attribute, EsploroSchema::Types.Instance(::Lutaml::Model::Attribute)

        option :collection, EsploroSchema::Types::Bool, default: proc { false }

        option :wrapper, EsploroSchema::Types::Bool, default: proc { false }

        option :unwrapped_name, EsploroSchema::Types::UnwrappedAttributeName, optional: true

        option :wrapped_name, EsploroSchema::Types::WrappedAttributeName, optional: true
      end

      alias collection? collection

      alias wrapper? wrapper

      def ivar
        @ivar ||= :"@#{normalized_name}"
      end

      def normalized_name
        @normalized_name ||= wrapper? ? unwrapped_name : name
      end

      def normalizer_method
        :"normalize_#{normalized_name}"
      end

      def derive_assignment
        <<~RUBY.strip_heredoc.strip
        #{ivar} = #{normalizer_method}
        RUBY
      end

      def normalizer_method_body
        if wrapper?
          <<~RUBY
          def #{normalizer_method}
            retrieve_wrapped_value_for(#{normalized_name.inspect})
          end
          RUBY
        elsif collection?
          <<~RUBY
          def #{normalizer_method}
            retrieve_collected_value_for(#{normalized_name.inspect})
          end
          RUBY
        else
          <<~RUBY
          def #{normalizer_method}
            retrieve_value_for(#{normalized_name.inspect})
          end
          RUBY
        end
      end
    end
  end
end
