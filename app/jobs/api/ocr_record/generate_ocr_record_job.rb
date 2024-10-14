# frozen_string_literal: true

class Api::OcrRecord::GenerateOcrRecordJob < ApplicationJob
  queue_as :default

  def perform(wallet_service:, job_params:)
    create_class_result = Api::OcrRecord::CreateOcrClass.new(wallet_service).run
    unless create_class_result[:success]
      return json: { error: "Unable to create google loyalty class #{create_class_result}" },
             status: :bad_request and return
    end

    class_id = create_class_result[:loyalty_class_id]
    qr_code_data = OcrRecord::OcrRecord.map_params(job_params, class_id)
    create_instance_result = Api::OcrRecord::CreateOcrRecordInstance.new(wallet_service).run(job_params, qr_code_data)
    return create_instance_result unless create_instance_result[:success]

    objs = Api::OcrRecord::RenderOcrObject.new(wallet_service).run(class_id, create_instance_result[:id])
    { success: objs[:success], body: objs[:success] ? objs[:body] : objs[:error] }
  end
end
