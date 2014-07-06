class AttendancesController < InheritedResources::Base
  def create
    @users = User.find(params[:project][:user_ids]) rescue []

    @users.each do |u|
      @attendance = Attendance.new

      @attendance.update_attributes(:absent => true)
      @attendance.update_attributes(:user_id => u.id)

      @user = User.find_by_id(u.id)
      if @user.absent == nil
abs = 1
        @user.update_attributes(:absent => abs)      else
        abs = @user.absent + 1
        @user.update_attributes(:absent => abs)
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
end
