# frozen_string_literal: true

class OcrRecord::OcrRecord
  def initialize(ocr_parameters, class_id)
    @ocr_parameters = ocr_parameters
    @class_id = class_id
  end

  def map_params
    patient_name = params[:prescription][:patientName]
    date = DateTime.now.strftime('%Y-%m-%d').to_s

    {
      patient_name: patient_name,
      date: date,
      class_id: class_id,
      program: 'Find My Eye Test',
      prescription: params[:prescription],
      history_link: "https://yourwebsite.com/patient-history/#{patient_name}"
    }.to_json
  end

  private

  attr_reader :ocr_parameters, :class_id
end
