# frozen_string_literal: true

module Testing
  class GQLShaper
    def mutation(...)
      ::Testing::GQL::MutationShaper.build(...)
    end

    def named(...)
      ::Testing::GQL::NamedObjectShaper.build(...)
    end

    def object(...)
      ::Testing::GQL::ObjectShaper.build(...)
    end

    alias query object

    def objects(...)
      ::Testing::GQL::ObjectsShaper.build(...)
    end

    alias array objects

    # @param [String, Symbol] name
    # @return [Hash]
    def empty_mutation(name)
      query do |q|
        q[name] = nil
      end
    end

    def top_level_unauthorized
      array do |a|
        a.item do |o|
          o.prop :extensions do |ext|
            ext[:code] = "FORBIDDEN"
          end

          o[:message] = I18n.t("server_messages.auth.forbidden")
        end
      end
    end

    def attribute_errors(...)
      ::Testing::GQL::AttributeErrorsBuilder.build(...)
    end

    def attribute_error_on(...)
      ::Testing::GQL::AttributeErrorBuilder.build(...)
    end
  end
end
