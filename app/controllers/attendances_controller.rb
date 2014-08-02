class AttendancesController < InheritedResources::Base
  before_action :authenticate_user!
    layout 'application1'

  def create
    @users = User.find(params[:project][:user_ids]) rescue nil
    @carrier = {"Verizon"=>"@vtext.com", "AT&T"=>"@txt.att.net","Boost Mobile" => "@myboostmobile.com", "Cellular One"=>"@mobile.celloneusa.com","Metro PCS"=>"@mymetropcs.com","Nextel"=>"@messaging.nextel.com","Sprint"=>"@messaging.sprintpcs.com","T-Mobile"=>"@tmomail.net","Tracfone"=>"@txt.att.net"}
   
   
   
   
   
   
   
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
