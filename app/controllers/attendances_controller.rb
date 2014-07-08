class AttendancesController < InheritedResources::Base
  def create
    @users = User.find(params[:project][:user_ids]) rescue []

    #this will not work atm hence there is 2 different types of absences fix that first
    @users.each do |u|
      @attendance = Attendance.new(attendance_params)
      if @attendance.event == "PT"
        @attendance.update_attributes(:absent => true)
        @attendance.update_attributes(:user_id => u.id)
        @attendance.update_attributes(:event=> @attendance.event)

        @user = User.find_by_id(u.id)
        if @user.absentpt == nil
          abs = 1
          @user.update_attributes(:absentpt => abs)
        else
          abs = @user.absentpt + 1
          @user.update_attributes(:absentpt => abs)
        end
      end
      
      if @attendance.event == "LLAB"
        @attendance.update_attributes(:absent => true)
        @attendance.update_attributes(:user_id => u.id)
        @attendance.update_attributes(:event=> @attendance.event)

        @user = User.find_by_id(u.id)
        if @user.absentllab == nil
          abs = 1
          @user.update_attributes(:absentllab => abs)
        else
          abs = @user.absentllab + 1
          @user.update_attributes(:absentllab => abs)
        end
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
