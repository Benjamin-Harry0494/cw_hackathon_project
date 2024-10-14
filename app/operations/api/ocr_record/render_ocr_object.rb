# frozen_string_literal: true

class Api::OcrRecord::RenderOcrObject
  def initialize(wallet_service:)
    @wallet_service = wallet_service
  end

  def run(class_id, object_id)
    list_object_of_class(class_id, object_id)
  end

  private

  attr_reader :wallet_service

  def list_object_of_class(class_id, object_id)
    response = @wallet_service.list_genericobjects(class_id: class_id)
    wallet_items = object_map(response)
    matching_item = wallet_items.find { |item| item[:id] == object_id }

    { success: true, body: matching_item }
  rescue Google::Apis::ClientError => e
    { success: false, body: 'No items found', error: e.message }
  end

  def object_map(response)
    response.resources.map do |item|
      qr_code_data = item.barcode.value.present? ? JSON.parse(item.barcode.value) : {}

      {
        id: item.id,
        class_id: item.class_id,
        state: item.state,
        card_title: item.card_title.default_value.value,
        patient_name: item.text_modules_data.first.localized_body.default_value.value,
        qr_code_items: {
          patient_name: qr_code_data['patient_name'],
          date: qr_code_data['date'],
          class_id: qr_code_data['class_id'],
          program: qr_code_data['program'],
          history_link: qr_code_data['history_link'],
          prescription: qr_code_data['prescription']
        }
      }
    end
  end
end
