class Api::V1::Users::DailyLogEntriesController < ApplicationController
  def show
    render json: DailyLogEntrySerializer.new(DailyLogEntry.find(params[:id]))
  end

  def create
    daily_log_entry = DailyLogEntry.new(daily_log_entry_params)
    if daily_log_entry.save
      render json: DailyLogEntrySerializer.new(daily_log_entry), status: :created
    else
      render json: ErrorSerializer.new(daily_log_entry).serializable_hash[:data][:attributes],  status: :unprocessable_entity
    end
  end

  private

  def daily_log_entry_params
    params.permit(:user_id,
      :mood,
      :depression_score,
      :anxiety_score,
      :sleep_score,
      :energy_levels,
      :notes,
      :meditation,
      :sociability,
      :exercise)
  end
end
