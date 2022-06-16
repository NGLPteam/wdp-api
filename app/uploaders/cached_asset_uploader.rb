# frozen_string_literal: true

# An uploader for storing assets retrieved during harvesting and cached by their unique URL.
#
# Unlike other uploaders, it does _not_ background its asset promotion or destruction logic,
# as we want the stored asset available immediately, and it does not perform any sort of
# derivative generation or anything else that would warrant the delay.
#
# @see HarvestCachedAsset
class CachedAssetUploader < Shrine
  plugin :add_metadata
  plugin :refresh_metadata
  plugin :infer_extension, force: true
  plugin :remote_url, max_size: 5.gigabytes
  plugin :signature
  plugin :validation_helpers
  plugin :restore_cached_data
  plugin :metadata_attributes, filename: "file_name", size: "file_size", mime_type: "content_type", sha256: "signature"

  add_metadata :sha256, skip_nil: true do |io, store: nil, **options|
    calculate_signature(io, :sha256, format: :base64) unless store == :cache
  end

  Attacher.validate do
    validate_max_size 5.gigabytes
  end

  Attacher.promote_block { promote }
  Attacher.destroy_block { destroy }
end
