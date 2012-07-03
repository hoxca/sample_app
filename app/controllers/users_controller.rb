class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
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
