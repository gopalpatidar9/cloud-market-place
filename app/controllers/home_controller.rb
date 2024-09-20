class HomeController < ApplicationController
  before_action :authenticate_user!, only:[:requerment , :services]
  def index
  end

  def about
  end


  def services
  end

  def documention
  end

  def requerment
  end
end
