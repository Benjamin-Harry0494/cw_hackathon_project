# frozen_string_literal: true

class Api::OcrRecord::CreateOcrRecordInstance
  def initialize(wallet_service:)
    @wallet_service = wallet_service
  end

  def run(params, qr_code_data)
    uuid = "#{class_id}.#{SecureRandom.uuid}"
    patient_name = params[:prescription][:patientName]
    generic_object = generate_generic_object(uuid, qr_code_data, patient_name)
    create_ocr_instance(generic_object)
  end

  private

  def create_ocr_instance(generic_object)
    result = wallet_service.insert_genericobject(generic_object)
    { success: true, message: 'Generic object instance created successfully', result: result, id: id }
  rescue Google::Apis::ClientError => e
    { success: false, message: 'Failed to create generic object instance', error: e.message, result: result }
  end

  def generate_generic_object(id, qr_code_data, patient_name)
    WALLET_OBJECTS::GenericObject.new(
      id: id,
      class_id: class_id,
      state: 'active',

      barcode: WALLET_OBJECTS::Barcode.new(
        type: 'qrCode',
        value: qr_code_data,
        alternate_text: 'Scan for patient history'
      ),

      header: WALLET_OBJECTS::LocalizedString.new(
        default_value: WALLET_OBJECTS::TranslatedString.new(
          language: 'en',
          value: 'Find You Personal Eye Test'
        )
      ),

      hero_image: WALLET_OBJECTS::Image.new(
        source_uri: WALLET_OBJECTS::ImageUri.new(
          uri: 'https://cdn.vectorstock.com/i/500p/71/73/magnifier-with-eye-outline-icon-find-vector-31557173.jpg'
        )
      ),

      card_title: WALLET_OBJECTS::LocalizedString.new(
        default_value: WALLET_OBJECTS::TranslatedString.new(
          language: 'en',
          value: 'Find My Eye Test'
        )
      ),

      text_modules_data: [
        WALLET_OBJECTS::TextModuleData.new(
          header: 'Patient Name',
          body: patient_name.nil? || patient_name.empty? ? 'Unknown Patient' : patient_name,
          localized_header: WALLET_OBJECTS::LocalizedString.new(
            default_value: WALLET_OBJECTS::TranslatedString.new(
              language: 'en',
              value: 'Patient Name'
            )
          ),
          localized_body: WALLET_OBJECTS::LocalizedString.new(
            default_value: WALLET_OBJECTS::TranslatedString.new(
              language: 'en',
              value: patient_name.nil? || patient_name.empty? ? 'No patient information available.' : patient_name
            )
          )
        )
      ],

      links_module_data: WALLET_OBJECTS::LinksModuleData.new(
        uris: [
          WALLET_OBJECTS::Uri.new(
            uri: 'https://yourwebsite.com/patient-history',
            description: 'View full patient history'
          )
        ]
      )
    )
  end
end
