class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  before_filter :redirect_signed_user, only: [:new, :create]

  def index
    # @users = User.all
    @users = User.paginate(page: params[:page],
                           per_page: 5,
                           order: "common_name")
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def edit
    # Managed by before_filter :correct_user
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  rescue_from ActiveRecord::StatementInvalid do |exception|
    if exception.message =~ /ConstraintException/
      rescue_constraint(exception)
    else
      raise
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user 
    else
      render 'new'
    end
  end

  def destroy
    user = User.find(params[:id])
    if current_user?(user)
      flash[:error] = "Don't delete yourself !"
    else
      user.destroy
      logger.info ("page: #{params[:page]}")
      flash[:success] = "User destroyed."
    end
    redirect_to users_path(:page => params[:page])
  end

  protected
  def rescue_constraint(exception)
    @ex_message = "Email address already taken from another account !"
    logger.info "Trapped SQL Constraint: #{exception.message}"
    render 'new'
  end

  private

   def correct_user
     @user = User.find(params[:id])
     redirect_to root_path unless current_user?(@user)
   end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def redirect_signed_user
    redirect_to root_path if signed_in?
  end

end
