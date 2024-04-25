# frozen_string_literal: true

RSpec::Matchers.define :be_an_encoded_id do
  match do |actual|
    @check_state ||= :none

    global_id = parse_id actual

    global_id.kind_of?(GlobalID) && validate_existence?(global_id)
  end

  chain :of_a_deleted_model do
    @check_state = :deleted
  end

  chain :of_an_existing_model do
    @check_state = :existing
  end

  def parse_id(id)
    global_id = MeruAPI::Container[:node_verifier].verify id, purpose: :node

    GlobalID.parse global_id
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    nil
  end

  def validate_existence?(global_id)
    case @check_state
    when :deleted
      check_deleted?(global_id)
    when :existing
      check_existing?(global_id)
    else
      true
    end
  end

  def check_deleted?(global_id)
    global_id.find.blank?
  rescue ActiveRecord::RecordNotFound
    true
  end

  def check_existing?(global_id)
    global_id.find.present?
  rescue ActiveRecord::RecordNotFound
    false
  end
end
