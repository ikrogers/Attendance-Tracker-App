ActiveAdmin.register User do

  controller do
    def update_resource(object, attributes)

      update_method = attributes.first[:password].present? ? :update_attributes : :update_without_password

      object.send(update_method, *attributes)

    end
    
    
    
    
    
    alias_method :destroy_user, :destroy

    #Custom cascading destroy action where it will delete everything that belongs to the user then deletes the actual user
    def destroy_resource(object)
      #If user is a group leader thenit will nullify position of the group leader
      @group = Group.where(users_id: object.id) rescue nil
      if @group != nil
        @group.each do |group|
          group.update_attributes(:users_id => nil)
        end
      end
      #If user is not a group leader it will remove him/her from every group he/she belongs to
      @ingroups = InGroup.where(users_id: object.id) rescue nil
      if @ingroups != nil
      @ingroups.destroy_all
      end

      #All attendance records made by that user will be nullified and records for the user will be removed
      @attrec = Attendance.where(user_id: object.id) rescue nil
      if @attrec != nil
      @attrec.destroy_all
      end
      @atttrack = Attendance.where(tracker_id: object.id) rescue nil
      if @atttrack != nil
        @atttrack.each do |at|
          at.update_attributes(:tracker_id => nil)
        end
      end

      #If user is deleted all messages from messagelist will be removed. If for some magical reason user is being deleted is admin then the message and all 
      #message listst will be destroyed
      @msglist = MessageList.where(users_id: object.id) rescue nil
      if @msglist!=nil
      @msglist.destroy_all
      end

      @msg = Message.where(users_id: object.id) rescue nil
      if @msglist != nil
        @msg.each do |m|
          @all = MessageList.where(messages_id: m.id)
          @all.destroy_all
        end
      @msg.destroy_all
      end
      
      #Destroy the user
      
      @user = User.find_by_id(object.id).destroy
      if @user.uberadmin != true
        @user.destroy
      else
      end
    end

  end

  form do |f|
    f.inputs "User Details" do
      f.input :fname
      f.input :lname
      f.input :phone
      f.input :carrier,:as => :select, :collection => options_for_select(["AT&T","Verizon", "Boost Mobile", "Cellular One", "Metro PCS", "Nextel", "Sprint", "T-Mobile", "Tracfone"])
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :admin
      f.input :tracker
    end
    f.actions
  end

  permit_params :email, :password, :password_confirmation, :admin, :tracker, :fname, :lname, :carrier

# See permitted parameters documentation:
# https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#  permitted = [:permitted, :attributes]
#  permitted << :other if resource.something?
#  permitted
# end

end
