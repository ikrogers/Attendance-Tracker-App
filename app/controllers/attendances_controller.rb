class AttendancesController < InheritedResources::Base
  before_action :authenticate_user!
  layout 'application1'
  def create
    @users = User.find(params[:project][:user_ids]) rescue nil
    @today = Time.now.strftime("%D")
    @carrier = {"Verizon"=>"@vtext.com", "AT&T"=>"@txt.att.net","Boost Mobile" => "@myboostmobile.com", "Cellular One"=>"@mobile.celloneusa.com","Metro PCS"=>"@mymetropcs.com","Nextel"=>"@messaging.nextel.com","Sprint"=>"@messaging.sprintpcs.com","T-Mobile"=>"@tmomail.net","Tracfone"=>"@txt.att.net"}

    @group = Group.find_by_id(attendance_params[:groups_id])
    @users_in_group = InGroup.where(groups_id: @group)

    @users_in_group.each do |user|
      @user = User.find_by_id(user.users_id)
      @att = Attendance.find_by(user_id: @user.id, event: attendance_params[:event], date_recorded: @today) rescue nil
      if @att == nil 
        if @users==nil
          else
          @users.each do |u|
            attendancept = Attendance.where(user_id: u.id, event: "PT")
            attendancellab = Attendance.where(user_id: u.id, event: "LLAB")
            if u.id == @user.id
              @attendance = Attendance.new(attendance_params)
              @attendance.update_attributes(:absent => true, :user_id => @user.id, :date_recorded => @today, :tracker_id => current_user.id)
              if @attendance.event == "PT"
                if attendancept.count <= 9
                   UserMailer.absence_notify(u, attendance_params[:event]).deliver
                   UserMailer.absence_notify_text(u, [u.phone, @carrier[u.carrier]].join(""), attendance_params[:event]).deliver
                end
              end   
              if @attendance.event == "LLAB"
                 if attendancellab.count <= 4
                    UserMailer.absence_notify_text(u, [u.phone, @carrier[u.carrier]].join(""), attendance_params[:event]).deliver
                    UserMailer.absence_notify(u, attendance_params[:event]).deliver
                 end
              end
              @attendance.save
            end
          end
        end
      else #if user has no record for today
        if @users == nil 
           attendancept = Attendance.where(user_id: @user.id, event: "PT")
            attendancellab = Attendance.where(user_id: @user.id, event: "LLAB")
            @att.destroy
            if attendance_params[:event] == "PT"
                if attendancept.count <= 9
                   UserMailer.absence_removed_notify(@user, attendance_params[:event]).deliver
                   UserMailer.absence_removed_notify_text(@user, [@user.phone, @carrier[@user.carrier]].join(""), attendance_params[:event]).deliver
                end
              end   
              if attendance_params[:event]== "LLAB"
                 if attendancellab.count <= 4
                    UserMailer.absence_removed_notify_text(@user, [@user.phone, @carrier[@user.carrier]].join(""), attendance_params[:event]).deliver
                    UserMailer.absence_removed_notify(@user, attendance_params[:event]).deliver
                 end
              end  
        else #checks if user is selected in absent array. if present does nothing if not present deletes the record
          @users.each do |u|
            @flag = false
            if u.id == @user.id
              @flag = true
            break
            else
              @flag = false
            end
          end
          if @flag == false
          @att.destroy
          attendancept = Attendance.where(user_id: @user.id, event: "PT")
            attendancellab = Attendance.where(user_id: @user.id, event: "LLAB")
            if attendance_params[:event] == "PT"
                if attendancept.count <= 9
                   UserMailer.absence_removed_notify(@user, @attendance.event).deliver
                   UserMailer.absence_removed_notify_text(@user, [@user.phone, @carrier[@user.carrier]].join(""), @attendance.event).deliver
                end
              end   
              if attendance_params[:event] == "LLAB"
                 if attendancellab.count <= 4
                    UserMailer.absence_removed_notify_text(@user, [@user.phone, @carrier[@user.carrier]].join(""), @attendance.event).deliver
                    UserMailer.absence_removed_notify(@user, @attendance.event).deliver
                 end
              end
          end
        end
      end

    end

    respond_to do |format|
      format.html { redirect_to groups_path, notice: 'Attendance records updated' }
      format.mobile { redirect_to groups_path, notice: 'Attendance records updated' }
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

  def attendance_params
    params.require(:attendance).permit(:event, :absent, :user_id, :tracker_id, :groups_id)
  end

end
