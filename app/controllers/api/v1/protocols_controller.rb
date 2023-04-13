class Api::V1::ProtocolsController < ApplicationController
  def index
    render json: ProtocolSerializer.new(Protocol.all)
  end

  def show
    render json: ProtocolSerializer.new(Protocol.find(params[:id]))
  end
end