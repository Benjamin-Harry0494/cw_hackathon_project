# frozen_string_literal: true

class Api::V1::OcrRecord::CreateEntryController < ApplicationController
  skip_forgery_protection
  before_action :set_credentials
  WALLET_OBJECTS = Google::Apis::WalletobjectsV1

  def create
    puts 'Creating new record'
    result = Api::OcrRecord::GenerateOcrRecordJob.perform(wallet_service: @wallet_service, job_params: params)
    render result
  end

  def set_credentials
    @wallet_service = WALLET_OBJECTS::WalletobjectsService.new
    @creds = JSON.parse(File.read(Rails.root.join('config', 'credentials', 'find_my_eye_test_creds.json')))
    generate_access_token
  end

  private

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
end
