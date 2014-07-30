class MessagesController < InheritedResources::Base
  before_action :authenticate_user!
  
  
  layout 'application1'
  def create #This entire create block is more on less the same just repeated bunch of times. Only differences are what to do what based on if staements
              # Yes its redundant but it works fine
    @carrier = {"Verizon"=>"@vtext.com", "AT&T"=>"@txt.att.net","Boost Mobile" => "@myboostmobile.com", "Cellular One"=>"@mobile.celloneusa.com","Metro PCS"=>"@mymetropcs.com","Nextel"=>"@messaging.nextel.com","Sprint"=>"@messaging.sprintpcs.com","T-Mobile"=>"@tmomail.net","Tracfone"=>"@txt.att.net"}
    @message = Message.new(message_params)
    
    @message.save #fix this!!!!!!!
    @delivery = @message.delivery_method
    @confirm = @message.confirm
    @sendtogroup = Group.find(params[:project][:groups_id]) rescue nil
    @message.update_attributes(:users_id => current_user.id)
    if @sendtogroup == nil
    @users = User.all
    
     if @users != nil 
      @users.each do |u|
         @message_list = MessageList.new
         @message_list.update_attributes(:users_id => u.id, :messages_id => @message.id, :original_message => @message.messages)
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
      @message.update_attributes(:all_confirm => false)
      if @message.delivery_method == "Email+SMS"
        
        #SMS
        @users.each do |user|
          if user.phone != nil
            @msgl = MessageList.find_by(users_id: user.id, messages_id: @message.id)
            @msgl.gentoken
            @msgl.update_attributes(:original_message => @message.messages, :confirmed_recall => false, :confirmed_time => nil)
            phone = user.phone
            carrier = user.carrier
          @msgl.send_confirm_message_text(@msgl, @message.messages,[phone, @carrier[carrier]].join(""))
          end
        end

        #email
        @users.each do |user|
          if user.email != nil
            @msgl = MessageList.find_by(users_id: user.id, messages_id: @message.id)
            @msgl.gentoken
            @msgl.update_attributes(:original_message => @message.messages, :confirmed_recall => false, :confirmed_time => nil)
            
          @msgl.send_confirm_message(@msgl, @message.messages, user.email)
          end
        end

      end

      if @message.delivery_method == 'SMS'
        #SMS
        @users.each do |user|
          if user.phone != nil
            @msgl = MessageList.find_by(users_id: user.id, messages_id: @message.id)
            @msgl.gentoken
            @msgl.update_attributes(:original_message => @message.messages, :confirmed_recall => false, :confirmed_time => nil)
            phone = user.phone
            carrier = user.carrier
          @msgl.send_confirm_message_text(@msgl, @message.messages,[phone, @carrier[carrier]].join(""))
          end
        end
      end

      if @message.delivery_method == "Email"
        #email
        @users.each do |user|
          if user.email != nil
            @msgl = MessageList.find_by(users_id: user.id, messages_id: @message.id)
            @msgl.gentoken
            @msgl.update_attributes(:original_message => @message.messages, :confirmed_recall => false, :confirmed_time => nil)
            
          @msgl.send_confirm_message(@msgl, @message.messages, user.email)
          end
        end
      end

      
      
      respond_to do |format|
        if @message.save
          @message.update_attributes(:users_id => current_user.id)
          format.html { redirect_to new_message_path, notice: 'Message is successfully sent! Awaiting user confirmation' }
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
      
       if @users != nil 
      @users.each do |u|
         @message_list = MessageList.new
         @message_list.update_attributes(:users_id => u.id, :messages_id => @message.id, :original_message => @message.messages)
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
      @message.update_attributes(:all_confirm => false)     
      if @message.delivery_method == "Email+SMS"
        
        #SMS
        @users.each do |user|
          if user.phone != nil
            @msgl = MessageList.find_by(users_id: user.id, messages_id: @message.id)
            @msgl.gentoken
            @msgl.update_attributes(:original_message => @message.messages, :confirmed_recall => false, :confirmed_time => nil)
            phone = user.phone
            carrier = user.carrier
          @msgl.send_confirm_message_text(@msgl, @message.messages,[phone, @carrier[carrier]].join(""))
          end
        end

        #email
        @users.each do |user|
          if user.email != nil
            @msgl = MessageList.find_by(users_id: user.id, messages_id: @message.id)
            @msgl.gentoken
            @msgl.update_attributes(:original_message => @message.messages, :confirmed_recall => false, :confirmed_time => nil)
            
          @msgl.send_confirm_message(@msgl, @message.messages, user.email)
          end
        end

      end

      if @message.delivery_method == 'SMS'
        #SMS
        @users.each do |user|
          if user.phone != nil
            @msgl = MessageList.find_by(users_id: user.id, messages_id: @message.id)
            @msgl.gentoken
            @msgl.update_attributes(:original_message => @message.messages, :confirmed_recall => false, :confirmed_time => nil)
            phone = user.phone
            carrier = user.carrier
          @msgl.send_confirm_message_text(@msgl, @message.messages,[phone, @carrier[carrier]].join(""))
          end
        end
      end

      if @message.delivery_method == "Email"
        #email
        @users.each do |user|
          if user.email != nil
            @msgl = MessageList.find_by(users_id: user.id, messages_id: @message.id)
            @msgl.gentoken
            @msgl.update_attributes(:original_message => @message.messages, :confirmed_recall => false, :confirmed_time => nil)
            
          @msgl.send_confirm_message(@msgl, @message.messages, user.email)
          end
        end
      end

      
      
      respond_to do |format|
        if @message.save
          @message.update_attributes(:users_id => current_user.id)
          format.html { redirect_to new_message_path, notice: 'Message is successfully sent! Awaiting user confirmation' }
          format.json { render :show, status: :created, location: @message}
        else
          format.html { render :new }
          format.json { render json: @message.errors, status: :unprocessable_entity }
        end
      end
    end #end else
    end #If group was selected
  end #end create


  def received
    
  end


  def confirmation
    @user = MessageList.find_by_messageconfirmtoken!(params[:id])
  end

  def user_confirmations
    @users = User.all
  end

  def validate_message
    @carrier = {"Verizon"=>"@vtext.com", "AT&T"=>"@txt.att.net","Boost Mobile" => "@myboostmobile.com", "Cellular One"=>"@mobile.celloneusa.com","Metro PCS"=>"@mymetropcs.com","Nextel"=>"@messaging.nextel.com","Sprint"=>"@messaging.sprintpcs.com","T-Mobile"=>"@tmomail.net","Tracfone"=>"@txt.att.net"}
    @user = MessageList.find_by_messageconfirmtoken!(params[:id])
    @message = Message.find_by_id(@user.messages_id)
    @sendinguser = User.find_by_id(@message.users_id)
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
       
       @flag = true
       @users.each do |u|
         @msgl = MessageList.find_by(users_id: u.id, messages_id: @message.id)
         if @msgl.confirmed_recall == false
           @flag = false
           break
         end
       end
       
       if @flag == true
         @message.update_attributes(:all_confirm => true,:all_confirm_time => Time.now)
         
         
       #Delivers that recall has been completed based on user preferences  
       if @message.notify == "1" 
          if @message.notification_method == "Email+SMS"      
            UserMailer.notify(@message).deliver
            UserMailer.notify_text(@message, [@sendinguser.phone, @carrier[@sendinguser.carrier]].join("")).deliver
          end
          if @message.notification_method == "Email"      
            UserMailer.notify(@message).deliver
          end
          if @message.notification_method == "SMS"      
            UserMailer.notify_text(@message, [@sendinguser.phone, @carrier[@sendinguser.carrier]].join("")).deliver
          end       
       end
        
         
       else
         @message.update_attributes(:all_confirm => false)
       end
      redirect_to authenticated_root_path, :notice => "Recall message confirmed successfully. Thank you and have a good day!"
    else
      redirect_to confirmation_path, :notice => "Messages did not match. Please try again."
    end
  end
  
  def destroy
    @message = Message.find_by_id(params[:id]) rescue nil
    
    #When a message is deleted, all messagelists are removed
    @msglist = MessageList.where(messages_id: @message.id) rescue nil
    if @msglist != nil
      @msglist.destroy_all
    end
    
    @message.destroy
    
    respond_to do |format|
      format.html { redirect_to messages_path, notice: "Message removed!" }
  end

  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_message
    @message = Message.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.

  def message_params
    params.require(:message).permit(:confirm, :messages, :delivery_method, :groups_id, :notify, :notification_method, :users_id, :subject)
  end

end