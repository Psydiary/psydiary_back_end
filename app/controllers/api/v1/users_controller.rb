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

  def update_settings
    @user = User.find(update_params[:user_id]) 
    
    begin
      @user.email = update_params[:email] if !update_params[:email].nil?
      @user.data_sharing = update_params[:data_sharing]

      if update_params[:new_password].present?
        if update_params[:new_password] == update_params[:password_conf]
          if BCrypt::Password.new(@user.password_digest) == update_params[:current_password]
            @user.password = update_params[:new_password]
          else
            render json: ErrorSerializer.invalid_password, status: :unprocessable_entity
          end
        else
          render json: ErrorSerializer.invalid_combo, status: :unprocessable_entity
        end
      end

      @user.save!
      redirect_to api_v1_user_settings_path(@user.id), notice: 'Update Successful'
    rescue ActiveRecord::RecordInvalid => e
      if e
        render json: { errors: e.message }, status: :unprocessable_entity
      end
    end
    
    # if update_params[:email].present?
    #   if User.exists?(email: update_params[:email]) || @user.email != update_params[:email]
    #     serialized_errors = ErrorSerializer.email_already_exists
    #     render json: serialized_errors, status: :unprocessable_entity
    #   elsif !User.exists?(email: update_params[:email]) || @user.email == update_params[:email]
    #     @user.email = update_params[:email]
    #     @user.data_sharing = update_params[:data_sharing]
        
    #     @user.save

    #     redirect_to api_v1_user_settings_path(@user.id), notice: 'Update Successful'
    #   end
    # elsif !update_params[:email].present?

    #   serialized_errors = ErrorSerializer.blank_email
    #   render json: serialized_errors, status: :unprocessable_entity
    # end
    

  #     
  #   end
  end

  def omniauth
    user = User.from_omniauth(params)
    if user.valid? || user.persisted?
      serialized_user = render json: UserSerializer.new(user)
    else
      serialized_errors = ErrorSerializer.new(user).serializable_hash[:data][:attributes]
      render json: serialized_errors, status: :unprocessable_entity
    end
  end

  private

    def user_params
      params.permit(
        :name, 
        :user_id, 
        :email, 
        :password, 
        :protocol_id, 
        :data_sharing, 
        :ip_address
      )
    end

    def update_params
      params
      .require(:data)
      .require(:attributes)
      .permit(
        :email,
        :current_password,
        :new_password,
        :password_conf,
        :data_sharing,
      )
      .merge(user_id: params[:user_id])
    end
end
