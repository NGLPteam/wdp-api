# frozen_string_literal: true

module Harvesting
  module Metadata
    module ValueExtraction
      # @see https://dry-rb.org/gems/dry-transformer/master/
      module Functions
        extend Dry::Transformer::Registry
        extend Dry::Effects.Resolve(:dependencies)
        extend Dry::Monads[:result, :try, :list, :validated]
        extend Dry::Effects::Handler.Resolve

        import Dry::Transformer::ArrayTransformations
        import Dry::Transformer::ClassTransformations

        Procable = Harvesting::Types.Interface(:to_proc)

        Fn = Harvesting::Types.Interface(:call).constructor do |value|
          case value
          when Symbol, Procable then value.to_proc
          else
            value
          end
        end

        Bool = Harvesting::Types::Params::Bool.fallback(false)

        class << self
          def booleanize(input)
            Bool[input]
          end

          # Call an operation within the `WDPAPI::Container`. It must take only one
          # argument and either handle its own exceptions or risk interrupting the
          # pipeline.
          #
          # If it returns a result monad, use {.unwrap_result} to get at the value.
          #
          # @param [Object] input the input to be passed to the operation
          # @param [String] operation_name the name of an operation in the WDP-API container
          # @return [Object] the return value of the operation (probably a monad)
          def call_operation(input, operation_name)
            WDPAPI::Container[operation_name].call(input)
          end

          # @param [#compact] compactable
          # @return [#compact] the compacted object
          def compact(compactable)
            compactable.compact
          end

          # Enforce a dry-type on the input.
          #
          # @param [Object] input
          # @param [Dry::Types::Type] type
          # @return [Object]
          def enforce_type!(input, type)
            type[input]
          rescue Dry::Types::ConstraintError => e
            raise PipelineError, e.message
          end

          # @param [Object] left
          # @param [Object] right
          # @return [Boolean]
          def equals(left, right)
            left == right
          end

          # Extract values from a source.
          #
          # @param [Harvesting::Metadata::ExtractsValues] source
          # @return [Harvesting::Metadata::ValueExtraction::Struct]
          def extract_values!(source)
            enforce_type! source, Harvesting::Metadata::ExtractsValues::Type

            # Check if we memoized the values first
            extracted = source.respond_to?(:extracted_values) ? source.extracted_values : source.extract_values

            unwrap_result! extracted
          end

          # @param [#fetch] fetch_key
          # @param [Object] key
          # @raise [KeyError]
          # @return [Object]
          def fetch_key(fetchable, key)
            fetchable.fetch key
          end

          def fetch_dependency(key)
            dependencies.fetch key
          rescue KeyError
            raise PipelineError, "dependencies[#{key.inspect}] not found"
          end

          # @param [Object] key
          # @param [#to_s] dependency_key
          # @return [Object]
          def fetch_from_dependency(key, dependency_key)
            dependency = fetch_dependency dependency_key

            fetch_key dependency, key
          rescue KeyError
            raise PipelineError, "dependencies[#{dependency_key.inspect}][#{key.inspect}] not found"
          end

          def maybe_fetch_from_dependency(key, dependency_key)
            fetch_from_dependency key, dependency_key
          rescue PipelineError
            nil
          end

          def full_text_reference(kind, content)
            {
              lang: "en",
              kind: kind,
              content: content
            }
          end

          def full_text_html(content)
            full_text_reference("html", content)
          end

          def full_text_plain(content)
            full_text_reference("text", content)
          end

          # @param [Harvesting::Metadata::SectionMap] input
          # @param [<#to_sym>] tags
          # @return [Harvesting::Metadata::SectionMap]
          def funnel_section_map_by_tags(input, *tags)
            input.tagged_with(*tags)
          end

          def get_with_xpath(node, template, *parts)
            compiled = parts.map do |part|
              case part
              when Symbol
                dependencies.fetch(part)
              else
                part
              end
            end

            query = compiled.present? ? template % compiled : template

            node.at_xpath(query) || ::Utility::NullXMLElement.new
          end

          # @see https://api.rubyonrails.org/classes/Enumerable.html#method-i-index_by
          #
          # @param [Enumerable, #index_by] indexable
          # @param [#call, #to_proc, Symbol] fn
          # @return [Hash]
          def index_by(indexable, fn)
            fn = Fn[fn]

            indexable.index_by do |elm|
              fn.call elm
            end
          end

          # Join an array.
          #
          # @param [Array] arr
          # @param [String] sep
          # @return [String]
          def join_array(arr, sep)
            arr.join(sep)
          end

          # @param [#to_s] suffix
          # @param [String] prefix
          # @return [String, nil]
          def maybe_prefix(suffix, prefix)
            "#{prefix}#{suffix}" if suffix.present?
          end

          # A shorthand version of {.call_operation} for harvesting metadata operations.
          #
          # @see .call_operation
          # @param [Object] input
          # @param [String] suffix the rest of the name of
          # @return [Object] the return value of the operation (probably a monad)
          def metadata_operation(input, suffix)
            call_operation input, "harvesting.metadata.#{suffix}"
          end

          # @param [Array] arr
          # @param [#to_proc] predicate
          # @param [String] message
          # @raise [PipelineError]
          # @return [Object]
          def only_one!(arr, predicate, message: "One element matching the predicate expected")
            matches = arr.select(&predicate)

            raise PipelineError, message unless matches.one?

            matches.first
          end

          # Return the boolean presence of the input.
          #
          # @param [#present?] input
          # @return [Boolean]
          def presence(input)
            input.present?
          end

          # @param [Array, Enumerable, #select] arr
          # @param [#call] fn
          # @return [Array]
          def select_array(arr, fn)
            arr.select do |element|
              fn.call element
            end
          end

          alias filter_array select_array

          # @param [Array] arr
          # @return [Array]
          def sort_array(arr)
            arr.sort
          end

          # @todo This should be removed if the MODS xml for UCM comes back as expected
          #
          # @param [<String>] input
          # @return [<String>]
          def ucm_workaround_split!(input)
            WDPAPI::Container["testing.merced.split_identifiers"].(input)
          end

          # Remove all duplicates
          # @param [Array] arr
          # @return [Array]
          def uniq_array(arr)
            arr.uniq
          end

          # Unwrap a result monad and raise a pipeline error if it fails.
          #
          # @param [Dry::Monads::Result] result
          # @raise [PipelineError]
          # @return [Object]
          def unwrap_result!(result)
            result.value!
          rescue Dry::Monads::UnwrapError => e
            raise PipelineError, e.message
          end

          # Wrap the dependencies property hash around the pipeline.
          #
          # @param [Object] input
          # @param [#call] fn
          # @return [Object]
          def with_mapped_dependencies(input, fn)
            provide dependencies do
              fn.call(input)
            end
          end

          # Extract the text from an XML node.
          #
          # @param [Nokogiri::XML::Node, #text] node
          # @return [String]
          def xml_text(node)
            node.text
          end

          # Extract the HTML from an XML node.
          #
          # @param [Nokogiri::XML::Node, #text] node
          # @return [String]
          def xml_to_html(node)
            node.to_html
          end
        end
      end
    end
  end
end
