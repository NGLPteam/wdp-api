# frozen_string_literal: true

# We override this to use an indexable (`IMMUTABLE`) function.
PgSearch.unaccent_function = "immutable_unaccent"
