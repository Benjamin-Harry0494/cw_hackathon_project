class Api::V1::OcrRecord::SubmitPrescriptionController < ApplicationController
  skip_forgery_protection

  def create
    puts params

    # TODO: put params into a call to GenerateWallet

    render json: { message: 'Hello world' }
  end
end
