class Api::V1::UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      render json: UserSerializer.new(user).serializable_hash, status: :created
    else
      serialized_errors = ErrorSerializer.new(user).serializable_hash[:data][:attributes]
      render json: serialized_errors, status: :unprocessable_entity
    end
  end

  def show
    render json: UserSerializer.new(User.find(params[:id]))
  end

  private

    def user_params
      params.permit(:name, :email, :password, :protocol_id, :data_sharing, :ip_address)
    end
end
