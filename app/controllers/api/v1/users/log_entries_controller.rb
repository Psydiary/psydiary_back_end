class Api::V1::Users::LogEntriesController < ApplicationController
  def index
    user = User.find(params[:user_id])
    entries = user.user_entries
    render json: UserEntrySerializer.new(entries)
  end
end