class GroupsController < InheritedResources::Base
  before_action :authenticate_user!
  layout 'application1'
  def create
    @group = Group.new(group_params)
    @user = User.find(params[:project][:user_ids]) rescue []

    @u = User.find_by_id(@user[0])
    if @group.grouptype == "Attendance"
      @u.update_attributes(:tracker => true)
    else
      @u.update_attributes(:leader => true)
    end

    @group.update_attributes(:users_id => @u.id)

    @in_group = InGroup.new
    @in_group.update_attributes(:groups_id => @group.id)
    @in_group.update_attributes(:users_id => @u.id)

    respond_to do |format|
      if @group.save
        format.html { redirect_to groups_path, notice: 'Group was successfully created.' }
        format.mobile{ redirect_to groups_path, notice: 'Group was successfully created.' }
        format.js
        format.json { render action: 'show', status: :created, location: @group }
      else
        format.html { render action: 'new' }
        format.mobile { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @group= Group.find params[:id]

    respond_to do |format|
      @users = User.find(params[:project][:user_ids]) rescue nil
      @removeusers = User.find(params[:project][:user_remove]) rescue nil

      if @users != nil
        @users.each do |u|

          @in_group = InGroup.new

          @in_group.update_attributes(:groups_id => @group.id)
          @in_group.update_attributes(:users_id => u.id)
        end
      end

      if @removeusers != nil
        @removeusers.each do |u|
          @kill = InGroup.find_by_users_id(u.id)
          @ug = Group.find_by(users_id: u.id, id: @group.id) rescue nil
          if @ug == nil
          @kill.destroy
          end
        end
      end

      @user = User.find(params[:project][:user_id]) rescue nil
      if @user!=nil
        if @group.users_id != nil
          @user.each do |u|
            @u = User.find_by_id(u.id)
            @oldu = User.find_by_id(@group.users_id)
            if @oldu != @u
              if @group.grouptype =="Attendance"
                @oldu.update_attributes(:tracker => false)
                @u.update_attributes(:tracker => true)
              else
                @oldu.update_attributes(:leader => false)
                @u.update_attributes(:leader => true)
              end
            end
          end
        else
          @user.each do |u|
            @u = User.find_by_id(u.id)
            if @group.grouptype =="Attendance"
              @u.update_attributes(:tracker => true)
            else
              @u.update_attributes(:leader => true)
            end
          end
        end

        @group.update_attributes(:users_id => @u.id)

      end
      if @group.update(group_params)
        format.html { redirect_to groups_path, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end
  
  
 
  
  def destroy
    @group = Group.find_by_id(params[:id]) rescue nil
    @leader = User.find_by_id(@group.users_id) rescue nil
    #If group is deleted reset user status depending on grouptype
    if (@group.grouptype == "Attendance")
      @leader.update_attributes(:tracker => false)
    else
      @leader.update_attributes(:leader => false)
    end
    
    #If group is deleted remove all users from the group
    @all = InGroup.where(groups_id: @group.id) rescue nil
    if @all != nil
      @all.destroy_all
    end
    
    #Message sent to will update to -1 
    @allmsg = Messages.where(groups_id: @group.id) rescue nil
    if @allmsg != nil
      @allmsg.each do |m|
        m.update_attributes(:groups_id => -1)
      end
    end
    
    #Attendance records will be nullified and would be adjusted by a fake group interface
    @allatt = Attendance.where(groups_id: @group.id) rescue nil
    if @allatt!= nil
      @allatt.each do |at|
        at.update_attributes(:groups_id => nil)
      end
    end
    
    
    respond_to do |format|
      format.html { redirect_to groups_path, notice: 'Group removed!' }
    end
  end

  def group_params
    params.require(:group).permit(:name, :grouptype, :users_id, :groups_id)
  end
  
  
end
