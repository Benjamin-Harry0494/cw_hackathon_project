# frozen_string_literal: true

class Api::V1::OcrRecord::CreateEntryController < ApplicationController
  def create
    new_record = BuildOcrRecord(parmas)
    creds = JSON.parse(File.read(Rails.root.join('config', 'credentials', 'find_my_eye_test_creds.json')))
    iss = '3388000000022782175'

    google_wallet_payload = {
      iss: iss,
      aud: 'google',
      typ: 'savetoandroidpay',
      payload: {
        ocr_record: new_record
      }
    }

    google_wallet_url = 'https://walletobjects.googleapis.com/walletobjects/v1/issuer/insert'

    response = HTTParty.post(
      google_wallet_url,
      body: google_wallet_payload.to_json,
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{creds['api_key']}"
      }
    )

    if response.success?
      qr_code_url = response['qrCodeUrl']
      render json: { qr_code_url: qr_code_url }, status: :ok
    else
      render json: { error: 'Failed to create Google Wallet pass' }, status: :unprocessable_entity
    end
  end

  private

  def build_ocr_record(params)
    {
      user_id: params[:user_id],
      document_data: params[:document_data]
    }
  end
end
