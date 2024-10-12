# frozen_string_literal: true

class Api::V1::OcrRecord::CreateEntryController < ApplicationController
  def create
    new_record = OcrRecord(parmas)

  end
end
  