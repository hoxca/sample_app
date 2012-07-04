class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
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

  protected
  def rescue_constraint(exception)
    @ex_message = "Email address already taken from another account !"
    logger.info "Trapped SQL Constraint: #{exception.message}"
    render 'new'
  end


end
