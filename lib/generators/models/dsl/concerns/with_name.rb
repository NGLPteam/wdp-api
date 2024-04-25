# frozen_string_literal: true

module DSL
  module WithName
    def singular_name
      @singular_name ||= @name.to_s.singularize
    end

    def human_name
      @human_name ||= singular_name.humanize
    end

    def plural_name
      @plural_name ||= singular_name.pluralize
    end

    def key
      singular_name.to_sym
    end
  end
end
