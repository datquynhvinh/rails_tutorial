class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.paginate(page: params[:page], per_page: 10)
  end

  def show
    @user = User.find_by(id: params[:id])
    return unless valid_resource?(@user)
    @microposts = @user.microposts.paginate(page: params[:microposts_page], per_page: 10) unless @user.nil?

    following_ids = @user.active_relationships.pluck(:followed_id) << @user.id
    @activities = Activity.includes(:user).where(user_id: following_ids).paginate(page: params[:activities_page], per_page: 5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
    return unless valid_resource?(@user)
  end

  def update
    @user = User.find_by(id: params[:id])
    return unless valid_resource?(@user)
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    return unless valid_resource?(@user)
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private
    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end

    def correct_user
      @user = User.find_by(id: params[:id])
      redirect_to(root_url) unless @user == current_user
    end
end
