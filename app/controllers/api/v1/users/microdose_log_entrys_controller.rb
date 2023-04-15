class Api::V1::Users::MicrodoseLogEntrysController < ApplicationController
  def show
    render json: MicrodoseLogEntrySerializer.new(MicrodoseLogEntry.find(params[:id]))
  end

  private

  def microdose_log_entry_params
    params.permit(:user_id, :mood_before, :mood_after, :environment, :dosage, :intensity, :sociability, :journal_prompt, :journal_entry, :other_notes)
  end
end