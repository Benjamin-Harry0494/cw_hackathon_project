class Api::V1::SubmitPrescriptionController < ApplicationController
  def index
    render json: { message: 'Hello world' }
  end
end
