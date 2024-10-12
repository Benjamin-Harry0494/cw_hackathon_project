class Api::V1::OcrRecord::SubmitPrescriptionController < ApplicationController
  skip_forgery_protection

  def create
    puts params
    render json: { message: 'Hello world' }
  end
end
