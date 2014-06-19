class MessagesController < InheritedResources::Base
  def create
    #@CARRIER_TYPES = ["@sms.3rivers.net", "@paging.acswireless.com","@message.alltel.com","@txt.att.net","@txt.bellmobility.ca","@bellmobility.ca","@txt.bell.ca","@myboostmobile.com","@mobile.celloneusa.com","@csouth1.com","@txt.att.net","@comcastpcs.textmsg.com","@mymetropcs.com","@clearlydigital.com","@messaging.nextel.com","@pcsone.net","@messaging.sprintpcs.com","@tmomail.net","@msg.telus.com","@txt.att.net","@messaging.sprintpcs.com","@tmomail.net","@email.uscc.net","@vtext.com","@vmobl.com","@cellularonewest.com"]
    @carrier = {"Verizon"=>"@vtext.com", "AT&T"=>"@txt.att.net","Boost Mobile" => "@myboostmobile.com", "Cellular One"=>"@mobile.celloneusa.com","Metro PCS"=>"@mymetropcs.com","Nextel"=>"@messaging.nextel.com","Sprint"=>"@messaging.sprintpcs.com","T-Mobile"=>"@tmomail.net","Tracfone"=>"@txt.att.net"}
    @message = Message.new(message_params)
    @users = User.all
    @users.each do |user|
      if user.email != nil
        email = user.email
        UserMailer.recall_email(email,@message).deliver
      end
    end

    @users.each do |user|
      if user.phone != nil
        phone = user.phone
        carrier = user.carrier
        UserMailer.recall_text([phone, @carrier[carrier]].join(""),@message).deliver
      end
    end

    @users.each do |user|
      if user.email != nil
        user.update_attributes(:original_message => @message.messages)
        user.update_attributes(:confirmed_recall => false)

      user.send_confirm_message
      end
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

  def confirmation
    @user = User.find_by_messageconfirmtoken!(params[:id])
    

  end
  
  def validate_message
    @user = User.find_by_messageconfirmtoken!(params[:id])
    @entered = params[:entered_message]
    @original = @user.original_message
    if @entered == @original
      @user.update_attributes(:confirmed_recall => true)
      redirect_to authenticated_root_path, :notice => "Recall message confirmed successfully. Thank you and have a good day!"
    else
      redirect_to confirmation_path, :notice => "Messages did not match. Please try again."
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