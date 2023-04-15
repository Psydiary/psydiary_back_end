class Api::V1::Users::MicrodoseLogEntriesController < ApplicationController
  def show
    render json: MicrodoseLogEntrySerializer.new(MicrodoseLogEntry.find(params[:id]))
  end

  def index
    render json: MicrodoseLogEntrySerializer.new(MicrodoseLogEntry.user_entries(params[:user_id]))
    user = User.find(params[:user_id])

    #Note that this is all code for my attempt to try and serialize both entry types w/ one serializer
    # entries = user.user_entries
    # serialize(entries, UserEntrySerializer)
    # render entries, each_serializer: UserEntrySerializer
    # render json: UserEntrySerializer.new(entries)
  end

  # def serialize(collection, serializer, adapter = :json)
  #   UserEntrySerializer.new(collection, each_serializer: serializer, adapter: adapter)
  # end

  private

  def microdose_log_entry_params
    params.permit(:user_id, :mood_before, :mood_after, :environment, :dosage, :intensity, :sociability, :journal_prompt, :journal_entry, :other_notes)
  end
end
