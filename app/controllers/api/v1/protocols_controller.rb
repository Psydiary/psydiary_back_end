class Api::V1::ProtocolsController < ApplicationController
  def index
    render json: ProtocolSerializer.new(Protocol.protocols_by_user(params[:user_id]))
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
      serialized_errors = ErrorSerializer.new(protocol).serializable_hash[:data][:attributes]
      render json: serialized_errors, status: 400
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
      :other_notes,
      :created_by
    )
  end
end