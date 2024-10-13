# frozen_string_literal: true

class Api::V1::OcrRecord::CreateEntryController < ApplicationController
  skip_forgery_protection
  before_action :set_credentials
  GOOGLE_WALLET_URL = 'https://walletobjects.googleapis.com/walletobjects/v1/loyaltyClass'
  WALLET_OBJECTS = Google::Apis::WalletobjectsV1


  def create
    puts params
    puts 'Creating new record'
    qr_code_data = build_ocr_record(params)
    patient_name = params[:patient_name]
    puts 'Attempting to create loyalty class'
    create_class_result = create_generic_class
    puts create_class_result.inspect
    
    unless create_class_result[:success]
      render json: { error: "Unable to create google loyalty class #{result.parsed_response}" },
             status: :bad_request and return
    end

    class_id = create_class_result[:loyalty_class_id]
    create_instance_result = create_generic_instance(class_id, qr_code_data, patient_name)
    puts create_instance_result.inspect

    # response = HTTParty.post(
    #   GOOGLE_WALLET_URL,
    #   body: google_wallet_payload.to_json,
    #   headers: {
    #     'Content-Type' => 'application/json',
    #     'Authorization' => "Bearer #{@access_token}"
    #   }
    # )
    #
    # if response.success?
    #   qr_code_url = response['qrCodeUrl']
    #   render json: { qr_code_url: qr_code_url }, status: :ok
    # else
    #   puts response.parsed_response.inspect
    #   render json: { error: "Failed to create Google Wallet pass, response: #{response}" },
    #          status: :unprocessable_entity
    # end
  end

  def set_credentials
    puts 'Setting credentials'
    @wallet_service = WALLET_OBJECTS::WalletobjectsService.new
    @creds = JSON.parse(File.read(Rails.root.join('config', 'credentials', 'find_my_eye_test_creds.json')))
    generate_access_token
  end

  private

  def create_generic_class
    issuer_id = '3388000000022782190'

    generic_class = WALLET_OBJECTS::GenericClass.new(
      id: "#{issuer_id}.genericClass",
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
      ]
    )

    res = @wallet_service.insert_genericclass(generic_class)
    { success: true, message: 'Generic object created successfully', loyalty_class_id: "#{issuer_id}.offerClass", result: res }
  rescue Google::Apis::ClientError => e
    if e.message.include?("existingResource")
      { success: true, message: 'Generic object already exists', loyalty_class_id: "#{issuer_id}.offerClass", result: res }
    else
      { success: false, message: 'Unable to create generic class', error: e.message, result: res }
    end
  end

  def create_generic_instance(class_id, qr_code_data, patient_name)
    generic_object = WALLET_OBJECTS::GenericObject.new(
      id: class_id,
      class_id: class_id,
      state: 'active',
      barcode: WALLET_OBJECTS::Barcode.new(
        type: 'qrCode',
        value: qr_code_data,
        alternate_text: 'Scan for patient history'
      ),
      hero_image: WALLET_OBJECTS::Image.new(
        source_uri: WALLET_OBJECTS::ImageUri.new(uri: 'https://cdn.vectorstock.com/i/500p/71/73/magnifier-with-eye-outline-icon-find-vector-31557173.jpg')
      ),
      text_modules_data: [
        WALLET_OBJECTS::TextModuleData.new(
          header: 'Patient Name',
          body: patient_name
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

  def build_ocr_record(params)
    {
      user_id: params[:user_id],
      document_data: params[:document_data]
    }
  end
end
