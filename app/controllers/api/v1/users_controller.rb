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
  
  def login_user
    user = User.find_by(email: user_params[:email])
    if user && user.authenticate(user_params[:password])
      render json: UserSerializer.new(user).serializable_hash, status: 200
    elsif user != nil
      serialized_errors = ErrorSerializer.incorrect_password
      render json: serialized_errors, status: 404
    else
      serialized_errors = ErrorSerializer.user_not_found
      render json: serialized_errors, status: 404
    end
  end

  def show
    render json: UserSerializer.new(User.find(params[:id]))
  end

  def edit
    user = User.find(user_params[:user_id])

    if user.persisted? && !user.protocol.nil?
      render json: UserEditSerializer.new(UserProtocol.new(user, user.protocol))
    else
      serialized_errors = ErrorSerializer.user_not_found
      render json: serialized_errors, status: 404
    end
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      serialized_user = render json: UserSerializer.new(user)
    else
      serialized_errors = ErrorSerializer.new(user).serializable_hash[:data][:attributes]
      render json: serialized_errors, status: :unprocessable_entity
    end
  end

  def omniauth
    user = User.where(email: params[:info][:email])
    if user.first.uid.nil?
      serialized_errors = ErrorSerializer.wrong_login_type
      render json: serialized_errors, status: :unprocessable_entity
    else
      user = User.from_omniauth(params)
      if user.valid? || user.persisted?
        serialized_user = render json: UserSerializer.new(user)
      else
        serialized_errors = ErrorSerializer.new(user).serializable_hash[:data][:attributes]
        render json: serialized_errors, status: :unprocessable_entity
      end
    end
  end

  private

    def user_params
      params.permit(:name, :user_id, :email, :password, :protocol_id, :data_sharing, :ip_address)
    end
end
