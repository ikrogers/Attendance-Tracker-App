class MessagesController < InheritedResources::Base
  def create #This entire create block is more on less the same just repeated bunch of times. Only differences are what to do what based on if staements
              # Yes its redundant but it works fine
    @carrier = {"Verizon"=>"@vtext.com", "AT&T"=>"@txt.att.net","Boost Mobile" => "@myboostmobile.com", "Cellular One"=>"@mobile.celloneusa.com","Metro PCS"=>"@mymetropcs.com","Nextel"=>"@messaging.nextel.com","Sprint"=>"@messaging.sprintpcs.com","T-Mobile"=>"@tmomail.net","Tracfone"=>"@txt.att.net"}
    @message = Message.new(message_params)
    @delivery = @message.delivery_method
    @confirm = @message.confirm
    @sendtogroup = Group.find(params[:project][:groups_id]) rescue nil

    
    if @sendtogroup == nil
    @users = User.all
    if @message.confirm == 'No Confirmation'
      if @message.delivery_method == "Email+SMS"
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
            UserMailer.recall_email_text([phone, @carrier[carrier]].join(""),@message).deliver
          end
        end
      end

      if @message.delivery_method == 'SMS'
        @users.each do |user|
          if user.phone != nil
            phone = user.phone
            carrier = user.carrier
            UserMailer.recall_email_text([phone, @carrier[carrier]].join(""),@message).deliver
          end
        end
      end
      if @message.delivery_method == 'Email'
        @users.each do |user|
          if user.email != nil
            email = user.email
            UserMailer.recall_email(email,@message).deliver
          end
        end
      end
      
      respond_to do |format|
        if @message.save
          @message.update_attributes(:users_id => current_user.id)
          format.html { redirect_to new_message_path, notice: 'Message has been successfully sent!' }
          format.json { render :show, status: :created, location: @message}
        else
          format.html { render :new }
          format.json { render json: @message.errors, status: :unprocessable_entity }
        end
      end

    else #Required confirm
      if @message.delivery_method == "Email+SMS"
        @users.each do |user|
          if user.phone != nil
                  user.gentoken

            user.update_attributes(:original_message => @message.messages)
            user.update_attributes(:confirmed_recall => false)  
            user.update_attributes(:confirmed_time => nil)  

            phone = user.phone
            carrier = user.carrier
          user.send_confirm_message_text(@message.messages,[phone, @carrier[carrier]].join(""))
          end
        end

        @users.each do |user|
          if user.email != nil
            user.update_attributes(:original_message => @message.messages)
            user.update_attributes(:confirmed_recall => false)
                        user.update_attributes(:confirmed_time => nil)  


          user.send_confirm_message(@message.messages)
          end
        end

      end

      if @message.delivery_method == 'SMS'
        @users.each do |user|
          if user.phone != nil
                  user.gentoken

            user.update_attributes(:original_message => @message.messages)
            user.update_attributes(:confirmed_recall => false)
                        user.update_attributes(:confirmed_time => nil)  

            phone = user.phone
            carrier = user.carrier
          user.send_confirm_message_text(@message.messages,[phone, @carrier[carrier]].join(""))
          end
        end
      end

      if @message.delivery_method == "Email"
        @users.each do |user|
          if user.email != nil
                  user.gentoken

            user.update_attributes(:original_message => @message.messages)
            user.update_attributes(:confirmed_recall => false)
                        user.update_attributes(:confirmed_time => nil)  


          user.send_confirm_message(@message.messages)
          end
        end
      end

      
      
      respond_to do |format|
        if @message.save
          @message.update_attributes(:users_id => current_user.id)
          format.html { redirect_to user_confirmations_path, notice: 'Message is successfully sent! Awaiting user confirmation' }
          format.json { render :show, status: :created, location: @message}
        else
          format.html { render :new }
          format.json { render json: @message.errors, status: :unprocessable_entity }
        end
      end
    end #end else
    
    else #If the group was selected
         @sendtogroup.each do |g|
         @message.update_attributes(:groups_id => g.id)
         @gusers = InGroup.where(groups_id: g.id)
         @users = Array.new
         @gusers.each do |u| 
           @us = User.find_by_id(u.users_id) 
         @users << @us
        end 
        end

      if @message.confirm == 'No Confirmation'
      if @message.delivery_method == "Email+SMS"
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
            UserMailer.recall_email_text([phone, @carrier[carrier]].join(""),@message).deliver
          end
        end
      end

      if @message.delivery_method == 'SMS'
        @users.each do |user|
          if user.phone != nil
            phone = user.phone
            carrier = user.carrier
            UserMailer.recall_email_text([phone, @carrier[carrier]].join(""),@message).deliver
          end
        end
      end
      if @message.delivery_method == 'Email'
        @users.each do |user|
          if user.email != nil
            email = user.email
            UserMailer.recall_email(email,@message).deliver
          end
        end
      end
      
      respond_to do |format|
        if @message.save
          @message.update_attributes(:users_id => current_user.id)
          format.html { redirect_to new_message_path, notice: 'Message has been successfully sent!' }
          format.json { render :show, status: :created, location: @message}
        else
          format.html { render :new }
          format.json { render json: @message.errors, status: :unprocessable_entity }
        end
      end

    else #Required confirm
      if @message.delivery_method == "Email+SMS"
        @users.each do |user|
          if user.phone != nil
                  user.gentoken

            user.update_attributes(:original_message => @message.messages)
            user.update_attributes(:confirmed_recall => false)  
            user.update_attributes(:confirmed_time => nil)  

            phone = user.phone
            carrier = user.carrier
          user.send_confirm_message_text(@message.messages,[phone, @carrier[carrier]].join(""))
          end
        end

        @users.each do |user|
          if user.email != nil
            user.update_attributes(:original_message => @message.messages)
            user.update_attributes(:confirmed_recall => false)
                        user.update_attributes(:confirmed_time => nil)  


          user.send_confirm_message(@message.messages)
          end
        end

      end

      if @message.delivery_method == 'SMS'
        @users.each do |user|
          if user.phone != nil
                  user.gentoken

            user.update_attributes(:original_message => @message.messages)
            user.update_attributes(:confirmed_recall => false)
                        user.update_attributes(:confirmed_time => nil)  

            phone = user.phone
            carrier = user.carrier
          user.send_confirm_message_text(@message.messages,[phone, @carrier[carrier]].join(""))
          end
        end
      end

      if @message.delivery_method == "Email"
        @users.each do |user|
          if user.email != nil
                  user.gentoken

            user.update_attributes(:original_message => @message.messages)
            user.update_attributes(:confirmed_recall => false)
                        user.update_attributes(:confirmed_time => nil)  


          user.send_confirm_message(@message.messages)
          end
        end
      end

      
      
      respond_to do |format|
        if @message.save
          @message.update_attributes(:users_id => current_user.id)
          format.html { redirect_to user_confirmations_path, notice: 'Message is successfully sent! Awaiting user confirmation' }
          format.json { render :show, status: :created, location: @message}
        else
          format.html { render :new }
          format.json { render json: @message.errors, status: :unprocessable_entity }
        end
      end
    end #end else
    end #If group was selected
  end #end create

  def confirmation
    @user = User.find_by_messageconfirmtoken!(params[:id])
  end

  def user_confirmations
    @users = User.all
  end

  def validate_message
    @user = User.find_by_messageconfirmtoken!(params[:id])
    @message = Message.find_by_id(params[:id])
    @entered = params[:entered_message]
    @original = @user.original_message
    if @entered == @original
      @user.update_attributes(:confirmed_recall => true)
      @user.update_attributes(:confirmed_time => Time.now)
      
      #Grab all users this message was sent to
      @group = @message.groups_id rescue nil
       if @group != nil
         @groupusers = InGroup.where(groups_id: @group)
         @users = Array.new
         @groupusers.each do |u|
           @users << User.find_by_id(u.users_id)
         end
       else
         @users = User.all
       end
       
       
       flag = false
       @users.each do |u|
         if u.confirmed_recall == true
           flag = true
         else
           flag = false
           break
         end
       end
       if flag == false
        # @message.update_attributes(:all_confirm => false)
       else
         #@message.update_attributes(:all_confirm => true)
       end
      
      
      
      
      
      
      
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
    params.require(:message).permit(:confirm, :messages, :delivery_method, :groups_id)
  end

end