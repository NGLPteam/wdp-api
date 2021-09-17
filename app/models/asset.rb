# frozen_string_literal: true

class Asset < ApplicationRecord
  include GenericUploader::Attachment.new(:attachment)
  include GenericUploader::Attachment.new(:alternatives)
  include PreviewUploader::Attachment.new(:preview)
  include SchematicReferent

  pg_enum! :kind, as: "asset_kind"

  MEDIA_KINDS = %w[audio video image].freeze

  belongs_to :attachable, polymorphic: true, inverse_of: :assets

  belongs_to :community, optional: true
  belongs_to :collection, optional: true
  belongs_to :item, optional: true

  before_validation :enforce_foreign_key!

  scope :by_kind, ->(kind) { where(kind: kind) }
  scope :audios, -> { by_kind(:audio) }
  scope :images, -> { by_kind(:image) }
  scope :videos, -> { by_kind(:video) }
  scope :media, -> { by_kind(MEDIA_KINDS) }
  scope :pdfs, -> { by_kind(:pdf) }
  scope :documents, -> { by_kind(:document) }

  scope :sans_preview, -> { where(%(preview_data ->> 'id' IS NULL)) }
  scope :with_preview, -> { where(%(preview_data ->> 'id' IS NOT NULL)) }

  scope :with_unpromoted_preview, -> { where(%(preview_data ->> 'storage' = 'cache')) }

  validates :attachment, :name, :content_type, :file_size, presence: true

  # @return [String]
  def content_disposition
    ContentDisposition.attachment(name)
  end

  # @return [String]
  def download_url
    attachment.url(
      expires_in: 5.minutes.to_i,
      response_content_disposition: content_disposition,
    )
  end

  # @return [Class]
  def graphql_node_type
    if image?
      Types::AssetImageType
    elsif video?
      Types::AssetVideoType
    elsif audio?
      Types::AssetAudioType
    elsif pdf?
      Types::AssetPDFType
    elsif document?
      Types::AssetDocumentType
    else
      Types::AssetUnknownType
    end
  end

  # @return [void]
  def refresh_metadata!
    attachment_attacher.refresh_metadata!

    save!
  end

  private

  # @return [void]
  def enforce_foreign_key!
    case attachable
    when Community
      self.community = attachable
      self.collection = nil
      self.item = nil
    when Collection
      self.community = nil
      self.collection = attachable
      self.item = nil
    when Item
      self.community = nil
      self.collection = nil
      self.item = attachable
    else
      errors.add :attachable, "not a valid attachable"
    end
  end
end
