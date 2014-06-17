class MessagesController < InheritedResources::Base
  
  def create
    @message = Message.new(message_params)
    @users = User.all
    @users.each do |user|
      email = user.email
      UserMailer.recall_email(email,@message).deliver
    end
    
    
    
    
    
    
    
    respond_to do |format|
      if @message.save
        @message.update_attributes(:users_id => current_user.id)
        format.html { redirect_to @message, notice: 'Message is successfully sent!' }
        format.json { render :show, status: :created, location: @message}
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end 
  
  
  
  
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.

  def message_params
      params.require(:message).permit(:confirm, :messages, :delivery_method)
    end
  
  
end
