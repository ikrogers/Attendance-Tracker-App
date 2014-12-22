class AttendancesController < InheritedResources::Base
  before_action :authenticate_user!
  layout 'application1'
  

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
      format.html{redirect_to groups_path, notice: "Attendance successfully removed"}
    end
  end

  def attendance_params
    params.require(:attendance).permit(:event, :absent, :user_id, :tracker_id, :groups_id)
  end

end
