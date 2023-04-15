class Api::V1::Users::MicrodoseLogEntrysController < ApplicationController
  def show
    render json: MicrodoseLogEntrySerializer.new(MicrodoseLogEntry.find(params[:id]))
  end
  
  def create
    microdose_log_entry = MicrodoseLogEntry.new(microdose_log_entry_params)

    if microdose_log_entry.save
      render json: MicrodoseLogEntrySerializer.new(microdose_log_entry), status: :created
    else
      render json: ErrorSerializer.new(microdose_log_entry).serializable_hash[:data][:attributes],  status: :unprocessable_entity
    end
  end

  private

  def microdose_log_entry_params
    params.permit(:user_id, :mood_before, :mood_after, :environment, :dosage, :intensity, :sociability, :journal_prompt, :journal_entry, :other_notes)
  end
end
