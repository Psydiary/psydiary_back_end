class Api::V1::Users::MicrodoseLogEntriesController < ApplicationController
  def show
    user = User.find(params[:user_id])
    entries = user.microdose_log_entries

    render json: MicrodoseLogEntrySerializer.new(entries.find(params[:id]))
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
