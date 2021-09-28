# frozen_string_literal: true

class GenericUploader < Shrine
  plugin :add_metadata
  plugin :refresh_metadata
  plugin :infer_extension, force: true
  plugin :signature
  plugin :validation_helpers
  plugin :restore_cached_data
  plugin :metadata_attributes, kind: "kind", filename: "file_name", size: "file_size", mime_type: "content_type"

  add_metadata :sha256, skip_nil: true do |io, store: nil, **options|
    calculate_signature(io, :sha256, format: :base64) unless store == :cache
  end

  add_metadata :kind do |io, **options|
    WDPAPI::Container["assets.parse_kind"].call(io).value_or("unknown")
  end

  Attacher.validate do
    validate_max_size 5.gigabytes
  end
end
