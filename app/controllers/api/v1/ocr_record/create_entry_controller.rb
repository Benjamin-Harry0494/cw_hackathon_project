# frozen_string_literal: true

class Api::V1::OcrRecord::CreateEntryController < ApplicationController
  skip_forgery_protection
  before_action :set_credentials
  WALLET_OBJECTS = Google::Apis::WalletobjectsV1

  def create
    puts 'Creating new record'
    patient_name = params[:patient_name]
    create_class_result = create_generic_class
    unless create_class_result[:success]
      render json: { error: "Unable to create google loyalty class #{create_class_result}" },
             status: :bad_request and return
    end

    class_id = create_class_result[:loyalty_class_id]
    qr_code_data = build_ocr_record(params, class_id)
    create_instance_result = create_generic_instance(class_id, qr_code_data, patient_name)
    return unless create_instance_result[:success]

    objs = render_objects(class_id)
    render json: objs[:success] ? objs[:body] : objs[:error], status: objs[:success] ? :ok : :bad_request
  end

  def set_credentials
    puts 'Setting credentials'
    @wallet_service = WALLET_OBJECTS::WalletobjectsService.new
    @creds = JSON.parse(File.read(Rails.root.join('config', 'credentials', 'find_my_eye_test_creds.json')))
    generate_access_token
  end

  private

  def render_objects(class_id)
      response = @wallet_service.list_genericobjects(class_id: class_id)
      wallet_items = response.resources.map do |item|
        qr_code_data = item.barcode.value.present? ? JSON.parse(item.barcode.value) : {}

        {
          id: item.id,
          class_id: item.class_id,
          state: item.state,
          card_title: item.card_title.default_value.value,
          patient_name: item.text_modules_data.first.localized_body.default_value.value,
          qr_code_items: {
            patient_name: qr_code_data['patient_name'],
            class_id: qr_code_data['class_id'],
            program: qr_code_data['program'],
            history_link: qr_code_data['history_link']
          }
        }

      end
      { success: true, body: wallet_items }
  rescue Google::Apis::ClientError => e
    { success: false, body: 'No items found', error: e.message }
  end

  def create_generic_class
    issuer_id = '3388000000022782190'

    generic_class = WALLET_OBJECTS::GenericClass.new(
      id: "#{issuer_id}.genericClass.v3",
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

    res = @wallet_service.insert_genericclass(generic_class)
    { success: true, message: 'Generic object created successfully', loyalty_class_id: "#{issuer_id}.genericClass.v3", result: res }
  rescue Google::Apis::ClientError => e
    if e.message.include?('existingResource')
      { success: true, message: 'Generic object already exists', loyalty_class_id: "#{issuer_id}.genericClass.v3", result: res }
    else
      { success: false, message: 'Unable to create generic class', error: e.message, result: res }
    end
  end

  def create_generic_instance(class_id, qr_code_data, patient_name)
    id = "#{class_id}.#{SecureRandom.uuid}"
    puts "Providing class_id: #{class_id}, qr_code_data: #{qr_code_data}, patient_name: #{patient_name}"
    generic_object = WALLET_OBJECTS::GenericObject.new(
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
    puts generic_object.to_json

    result = @wallet_service.insert_genericobject(generic_object)
    { success: true, message: 'Generic object instance created successfully', result: result }
  rescue Google::Apis::ClientError => e
    { success: false, message: 'Failed to create generic object instance', error: e.message, result: result }
  end

  def generate_access_token
    puts 'Generating access token'
    scopes = ['https://www.googleapis.com/auth/wallet_object.issuer']
    authorization = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: StringIO.new(@creds.to_json),
      scope: scopes
    )
    authorization.fetch_access_token!
    @wallet_service.authorization = authorization
  end

  def build_ocr_record(params, class_id)
    {
      patient_name: 'This is your patients name',
      class_id: class_id,
      program: 'Find My Eye Test',
      history_link: "https://yourwebsite.com/patient-history/#{params[:patient_name]}"
    }.to_json
  end
end
