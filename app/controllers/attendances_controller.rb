class AttendancesController < InheritedResources::Base
  before_action :authenticate_user!
  layout 'application1'
  
  
  def create
    @users = User.find(params[:project][:user_ids]) rescue nil
    @carrier = {"Verizon"=>"@vtext.com", "AT&T"=>"@txt.att.net","Boost Mobile" => "@myboostmobile.com", "Cellular One"=>"@mobile.celloneusa.com","Metro PCS"=>"@mymetropcs.com","Nextel"=>"@messaging.nextel.com","Sprint"=>"@messaging.sprintpcs.com","T-Mobile"=>"@tmomail.net","Tracfone"=>"@txt.att.net"}

    if @users != nil
      users_in_group(params[:attendance][:groups_id]).each do |ug|
        if Attendance.find_by(:user_id => ug.id, :event => params[:attendance][:event], :date_recorded => Time.now.strftime("%D")).nil?
          if @users.include?(ug)
            @att = Attendance.create(:absent => true, :user_id => ug.id, :tracker_id => current_user.id, :date_recorded => Time.now.strftime("%D"), :event => params[:attendance][:event], :groups_id => params[:attendance][:groups_id])
          end
        else
          if @users.include?(ug)
          else
            Attendance.find_by(:user_id => ug.id, :event => params[:attendance][:event], :date_recorded => Time.now.strftime("%D")).destroy
          end  
        end
      end   
    else
      users_in_group(params[:attendance][:groups_id]).each do |ug|
        @att = Attendance.find_by(:user_id => ug.id, :event => params[:attendance][:event], :date_recorded => Time.now.strftime("%D")) rescue nil
        if @att != nil
          @att.destroy 
        end
      end
    end
    
    respond_to do |format|
        format.html { redirect_to groups_path, notice: 'Attendance  successfully recorded.' }
        format.mobile{ redirect_to groups_path, notice: 'Attendance was successfully recorded.' }
        format.json { render action: 'show', status: :created, location: @attendance }
    end

  end

  def updateattendance
    @attendance = Attendance.find_by_id(params[:id])
    @isnil = Attendance.where(groups_id: nil) rescue nil

    @gr = Group.find(params[:project][:group_id]) rescue nil
    if @gr != nil
      @gr.each do |g|
        @group = Group.find_by_id(g.id)
      end

      @attendance.update_attributes(groups_id: @group.id)
    end
    if @isnil.count >= 1
      redirect_to attendances_path, notice: 'Record was successfully updated.'
    else

      redirect_to groups_path, notice: 'Record was successfully updated.'
    end
  end

  def update_attendance_form
    @attendance = Attendance.find_by_id(params[:id])
  end
  
  def insert_attendance
    
  end
  
  def process_insert_attendance
        @users = User.find(params[:project][:user_ids]) rescue nil
        @event = params[:event]
        @date = Date.strptime(params[:date],"%m/%d/%Y").strftime("%D")
        @group = Group.find_by_id(params[:id])
        if @users != nil
        @users.each do |user|
          @attendance = Attendance.new
          @attendance.update_attributes(tracker_id: current_user.id, absent: true, user_id: user.id, event: @event, groups_id: @group.id, date_recorded: @date)
          
        end
        end
        respond_to do |format|
          if @users != nil
          format.html{redirect_to attendances_path(:attgroup_id => @group.id), notice: "Attendance successfully inserted"}
          else
            format.html{redirect_to attendances_path(:attgroup_id => @group.id), alert: "No changes were made. No users were selected or something went wrong. Please tyr again."}
          end
        end
  end
  
  
  def destroy
    @group = params[:attgroup_id]
    @attendance = Attendance.find_by_id(params[:id]) rescue nil
    if @attendance != nil
    @attendance.destroy
    end
    
    respond_to do |format|
      format.html{redirect_to groups_path, notice: "Attendance record successfully removed"}
    end
  end
private


 def users_in_group(group)
  @group=Group.find_by_id(group)
      @ingroup = InGroup.where(groups_id: @group.id)      
      @usersingroup = Array.new
      @ingroup.each do |ig|
        @usersingroup << User.find_by_id(ig.users_id)   
      end  
  return @usersingroup
  end
  
  def attendance_params
    params.require(:attendance).permit(:event, :absent, :user_id, :tracker_id, :groups_id)
  end

end
