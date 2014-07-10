class AttendancesController < InheritedResources::Base
  def create
    @users = User.find(params[:project][:user_ids]) rescue []
    
    
    @users.each do |u|
      @attendance = Attendance.new(attendance_params)
      @attendance.update_attributes(:tracker_id => current_user.id)
      if @attendance.event == "PT"
        @attendance.update_attributes(:absent => true)
        @attendance.update_attributes(:user_id => u.id)
        @attendance.update_attributes(:event=> @attendance.event)

        
      end
      
      if @attendance.event == "LLAB"
        @attendance.update_attributes(:absent => true)
        @attendance.update_attributes(:user_id => u.id)
        @attendance.update_attributes(:event=> @attendance.event)

       
      end
    end

    respond_to do |format|
      if @attendance.save
        format.html { redirect_to @attendance, notice: 'Group was successfully created.' }
        format.js
        format.json { render action: 'show', status: :created, location: @attendance }
      else
        format.html { render action: 'new' }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  def attendance_params
    params.require(:attendance).permit(:event)
  end
end
