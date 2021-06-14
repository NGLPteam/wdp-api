# frozen_string_literal: true

require "base64"
require "dry/matcher/result_matcher"
require "dry/transformer/all"
require "dry/types"
require "net/http"

Dry::Types.load_extensions :monads

FrozenRecord::Base.auto_reloading = Rails.env.development?
FrozenRecord::Base.base_path = Rails.root.join("lib", "frozen_record")
