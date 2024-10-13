# frozen_string_literal: true

class Api::V1::OcrRecord::CreateEntryController < ApplicationController
  skip_forgery_protection
  before_action :set_credentials
  GOOGLE_WALLET_URL = 'https://walletobjects.googleapis.com/walletobjects/v1/loyaltyClass'
  WALLET_OBJECTS = Google::Apis::WalletobjectsV1


  def create
    puts params
    puts 'Creating new record'
    new_record = build_ocr_record(params)
    patient_name = params[:patient_name]
    puts 'Attempting to create loyalty class'
    result = create_loyalty_class(patient_name)
    puts result.inspect

    #
    # unless result.success?
    #   render json: { error: "Unable to create google loyalty class #{result.parsed_response}" },
    #          status: :bad_request and return
    # end
    #
    # google_wallet_payload = {
    #   iss: issuer_id,
    #   aud: 'google',
    #   typ: 'savetoandroidpay',
    #   payload: {
    #     ocr_record: new_record
    #   }
    # }
    #
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

  def create_loyalty_class(patient_name)
    issuer_id = '3388000000022782190'

    loyalty_class = WALLET_OBJECTS::LoyaltyClass.new(
      id: "#{issuer_id}.loyaltyClass",
      issuer_name: 'Find My Eye Test',
      program_name: 'Patient Eye Test History',
      program_logo: WALLET_OBJECTS::Image.new(
        source_uri: WALLET_OBJECTS::ImageUri.new(uri: 'https://cdn.vectorstock.com/i/500p/71/73/magnifier-with-eye-outline-icon-find-vector-31557173.jpg')
      ),
      reward_status: 'active',
      review_status: 'draft',
      redemption_channel: 'both',
      text_modules: [
        WALLET_OBJECTS::TextModuleData.new(
          header: 'Patient Name',
          body: patient_name
        )
      ]
    )

    @wallet_service.insert_loyaltyclass(loyalty_class)
  rescue Google::Apis::ClientError => e
    Rails.logger.error("Failed to create loyalty class: #{e.message}")
    raise
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
