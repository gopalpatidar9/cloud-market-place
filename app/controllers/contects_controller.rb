class ContectsController < ApplicationController
  before_action :authenticate_user!
  def new
    @contect = Contect.new
  end

  def create
    @contect = current_user.contects.build(contect_params)
    if @contect.save
      flash[:notice] = 'Message sent successfully!'
      redirect_to new_contect_path
    else
      flash.now[:alert] = 'Failed to send message. Please try again.'
      render :send_message
    end
  end

  private
    
  def contect_params
    params.require(:contect).permit(:first_name, :last_name, :email, :message)
  end
end
