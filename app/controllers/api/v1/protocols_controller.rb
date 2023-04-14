class Api::V1::ProtocolsController < ApplicationController
  def index
    render json: ProtocolSerializer.new(Protocol.all)
  end

  def show
    render json: ProtocolSerializer.new(Protocol.find(params[:id]))
  end

  def create
    protocol = Protocol.new(protocol_params)

    if protocol.valid?
      protocol.save
      render json: ProtocolSerializer.new(Protocol.find(protocol.id)), status: 201
    else
      render json: ErrorSerializer.new(protocol.errors)
    end
  end

  private

  def protocol_params
    params.require(:protocol).permit(
      :id, 
      :name, 
      :days_between_dose,
      :dose_days, 
      :dosage, 
      :description, 
      :protocol_duration, 
      :break_duration, 
      :other_notes
    )
  end
end