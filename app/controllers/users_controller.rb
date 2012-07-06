class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

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
  end

  def edit
#    @user = User.find(params[:id])
  end

  def update
#    @user = User.find(params[:id])
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
    User.find(params[:id]).destroy
    logger.info ("page: #{params[:page]}")
    flash[:success] = "User destroyed."
    redirect_to users_path(:page => params[:page])
  end

  protected
  def rescue_constraint(exception)
    @ex_message = "Email address already taken from another account !"
    logger.info "Trapped SQL Constraint: #{exception.message}"
    render 'new'
  end

  private
  def signed_in_user
    store_location
    redirect_to signin_path, notice: "Please sign in." unless signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

end
