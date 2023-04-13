class Api::V1::ProtocolsController < ApplicationController
  def show
    render json: ProtocolSerializer.new(Protocol.find(params[:id]))
  end
end