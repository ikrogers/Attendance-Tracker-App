class AttendancesController < InheritedResources::Base
  def create
    @users = User.find(params[:project][:user_ids]) rescue nil
    @carrier = {"Verizon"=>"@vtext.com", "AT&T"=>"@txt.att.net","Boost Mobile" => "@myboostmobile.com", "Cellular One"=>"@mobile.celloneusa.com","Metro PCS"=>"@mymetropcs.com","Nextel"=>"@messaging.nextel.com","Sprint"=>"@messaging.sprintpcs.com","T-Mobile"=>"@tmomail.net","Tracfone"=>"@txt.att.net"}

    if @users != nil
    @users.each do |u|
      attendancept = Attendance.where(user_id: u.id, event: "PT")
      attendancellab = Attendance.where(user_id: u.id, event: "LLAB")
      @attendance = Attendance.new(attendance_params)
      @attendance.update_attributes(:tracker_id => current_user.id)
      
      if @attendance.event == "PT"
        @attendance.update_attributes(:absent => true)
        @attendance.update_attributes(:user_id => u.id)
        @attendance.update_attributes(:event=> @attendance.event)
        if attendancept.count <= 9
        UserMailer.absence_notify(u, @attendance.event).deliver
        UserMailer.absence_notify_text(u, [u.phone, @carrier[u.carrier]].join(""), @attendance.event).deliver
        end
      end
      
      if @attendance.event == "LLAB"
        @attendance.update_attributes(:absent => true)
        @attendance.update_attributes(:user_id => u.id)
        @attendance.update_attributes(:event=> @attendance.event)
        if attendancellab.count <= 4
        UserMailer.absence_notify_text(u, [u.phone, @carrier[u.carrier]].join(""), @attendance.event).deliver
        UserMailer.absence_notify(u, @attendance.event).deliver
        end
      end
    end

    respond_to do |format|
      if @attendance.save
        format.html { redirect_to @attendance, notice: 'Attendance recorded!' }
        format.js
        format.json { render action: 'show', status: :created, location: @attendance }
      else
        format.html { render action: 'new' }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
    else
      redirect_to groups_path, notice: 'Attendance recorded!'
    end
  end

  def attendance_params
    params.require(:attendance).permit(:event,:absent,:user_id,:tracker_id)
  end
end
