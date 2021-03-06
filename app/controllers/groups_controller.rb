class GroupsController < InheritedResources::Base
  before_action :authenticate_user!
  layout 'application1'
  def create
 
    @group = Group.new(group_params)
   

    @group.update_attributes(:ptdays => '', :llabdays => '')


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

    respond_to do |format|
    # This block sets PT and LLAB days for the group
      @group= Group.find params[:id]
      @ptdays = params[:project][:ptdays] rescue nil
      @llabdays = params[:project][:llabdays] rescue nil
      if @ptdays != nil
        @ptday_string = ''
        @ptdays.each do |d|
          @ptday_string = @ptday_string+'::'+d
        end
        @group.update_attributes(:ptdays => @ptday_string)
      end
      if @llabdays != nil
        @llabday_string = ''
        @llabdays.each do |d|
          @llabday_string = @llabday_string+'::'+d
        end
        @group.update_attributes(:llabdays => @llabday_string)
      end
    #-----------------------------------------
    #This block adds users to group
      @users = User.find(params[:project][:user_ids]) rescue nil
      @removeusers = User.find(params[:project][:user_remove]) rescue nil

      if @users != nil
        @users.each do |u|
          if (@group.grouptype.include? "Non-Attendance") == false
          @user = User.find_by_id(u.id)
          if (@group.grouptype.include? "Alternate") == false
            @user.update_attributes(:in_attendance_group => true)
          end
          end
          @in_group = InGroup.new

          @in_group.update_attributes(:groups_id => @group.id)
          @in_group.update_attributes(:users_id => u.id)
        end
      end
 #--------------------------------------------------------
 #This block removes users from the group
      if @removeusers != nil
        @removeusers.each do |u|
          @kill = InGroup.find_by_users_id(u.id)
          @ug = Group.find_by(users_id: u.id, id: @group.id) rescue nil
          if @ug == nil
          @user = User.find_by_id(u.id)
          @user.update_attributes(:in_attendance_group => false)
          @kill.destroy
          end
        end
      end
#-----------------------------------------------------------

#This block assigns an re assigns group leader
      @user = User.find(params[:project][:user_id]) rescue nil
      if @user!=nil
        if @group.users_id != nil
          @user.each do |u|
            @u = User.find_by_id(u.id)
            @oldu = User.find_by_id(@group.users_id)
            if @oldu != @u
          if (@group.grouptype.include? "Non-Attendance") == false
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
          if (@group.grouptype.include? "Non-Attendance") == false
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
    if @leader != nil
          if (@group.grouptype.include? "Non-Attendance") == false
      @leader.update_attributes(:tracker => false, :in_attendance_group => false)
    else
      @leader.update_attributes(:leader => false)
    end
    end
    #If group is deleted remove all users from the group
    @all = InGroup.where(groups_id: @group.id) rescue nil
    if @all != nil
          if (@group.grouptype.include? "Non-Attendance") == false
      @all.each do |a|
        @user = User.find_by_id(a.users_id)
        @user.update_attributes(:in_attendance_group => false)
        end
      end
    @all.destroy_all
    end

    #Message sent to will update to -1
    @allmsg = Message.where(groups_id: @group.id) rescue nil
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
    
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_path, notice: 'Group removed!' }
    end
  end

  def group_params
    params.require(:group).permit(:name, :grouptype, :users_id, :groups_id)
  end

end
