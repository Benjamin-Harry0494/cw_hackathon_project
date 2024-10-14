# frozen_string_literal: true

class Api::OcrRecord::CreateOcrClass
  def initialize
    @issuer_id = '3388000000022782190'
  end

  def run(wallet_service)
    create_ocr_class(wallet_service)
  end

  private

  attr_reader :issuer_id

  def create_ocr_class(wallet_service)
    class_id = "#{issuer_id}.genericClass.v4"
    generic_class = build_generic_class(class_id)
    res = wallet_service.insert_genericclass(generic_class)
    { success: true, message: 'Generic object created successfully', loyalty_class_id: class_id, result: res }
  rescue Google::Apis::ClientError => e
    if e.message.include?('existingResource')
      { success: true, message: 'Generic object already exists', loyalty_class_id: class_id, result: res }
    else
      { success: false, message: 'Unable to create generic class', error: e.message, result: res }
    end
  end

  def build_generic_class(class_id)
    WALLET_OBJECTS::GenericClass.new(
      id: class_id,
      issuer_name: 'Find My Eye Test',
      title: 'Find My Eye Test',
      provider: 'Find My Eye Test',
      review_status: 'draft',
      image_modules_data: [
        WALLET_OBJECTS::ImageModuleData.new(
          main_image: WALLET_OBJECTS::Image.new(
            source_uri: WALLET_OBJECTS::ImageUri.new(uri: 'https://cdn.vectorstock.com/i/500p/71/73/magnifier-with-eye-outline-icon-find-vector-31557173.jpg')
          )
        )
      ],
      text_modules_data: [
        WALLET_OBJECTS::TextModuleData.new(
          header: 'Patient Name',
          body: 'Details regarding your eye test.',
          localized_header: WALLET_OBJECTS::LocalizedString.new(
            default_value: WALLET_OBJECTS::TranslatedString.new(
              language: 'en',
              value: 'Patient Information'
            )
          ),
          localized_body: WALLET_OBJECTS::LocalizedString.new(
            default_value: WALLET_OBJECTS::TranslatedString.new(
              language: 'en',
              value: 'This module contains information about your eye test.'
            )
          )
        )
      ]
    )
  end
end
