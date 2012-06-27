class StaticPagesController < ApplicationController
  def home
  end

  def help
    @title = "Help"
  end

  def about
    @title = "About"
  end

end
