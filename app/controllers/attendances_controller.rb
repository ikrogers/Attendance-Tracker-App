class AttendancesController < InheritedResources::Base
  before_action :authenticate_user!
  layout 'application1'
  
  
  def create
    @absent_users = User.find(params[:project][:absent_user_ids]) rescue nil
    @tardy_users = User.find(params[:project][:tardy_user_ids]) rescue nil
    @carrier = {"Verizon"=>"@vtext.com", "AT&T"=>"@txt.att.net","Boost Mobile" => "@myboostmobile.com", "Cellular One"=>"@mobile.celloneusa.com","Metro PCS"=>"@mymetropcs.com","Nextel"=>"@messaging.nextel.com","Sprint"=>"@messaging.sprintpcs.com","T-Mobile"=>"@tmomail.net","Tracfone"=>"@txt.att.net"}

    if @absent_users != nil
      users_in_group(params[:attendance][:groups_id]).each do |ug|
        if Attendance.find_by(:absent => true, :absence_tardy => nil, :user_id => ug.id, :event => params[:attendance][:event], :date_recorded => Time.now.strftime("%D")).nil?
          if @absent_users.include?(ug)
            @att = Attendance.create(:absent => true, :user_id => ug.id, :tracker_id => current_user.id, :date_recorded => Time.now.strftime("%D"), :event => params[:attendance][:event], :groups_id => params[:attendance][:groups_id])
             UserMailer.absence_notify(u, attendance_params[:event]).deliver
                   UserMailer.absence_notify_text(u, [u.phone, @carrier[u.carrier]].join(""), attendance_params[:event]).deliver
          end
        else
          if @absent_users.include?(ug)
          else
            Attendance.find_by(:absent => true, :absence_tardy => nil, :user_id => ug.id, :event => params[:attendance][:event], :date_recorded => Time.now.strftime("%D")).destroy
          end  
        end
      end   
    else
      users_in_group(params[:attendance][:groups_id]).each do |ug|
        @att = Attendance.find_by(:absent => true, :absence_tardy => nil, :user_id => ug.id, :event => params[:attendance][:event], :date_recorded => Time.now.strftime("%D")) rescue nil
        if @att != nil
          @att.destroy 
        end
      end
    end
    
    if Event.find_by_event_name(params[:attendance][:event]).max_tardies != nil
     if @tardy_users != nil
      users_in_group(params[:attendance][:groups_id]).each do |ug|
        if Attendance.find_by(:tardy => true, :absence_tardy => nil, :user_id => ug.id, :event => params[:attendance][:event], :date_recorded => Time.now.strftime("%D")).nil?
          if @tardy_users.include?(ug)
            
            @att = Attendance.create(:tardy => true, :user_id => ug.id, :tracker_id => current_user.id, :date_recorded => Time.now.strftime("%D"), :event => params[:attendance][:event], :groups_id => params[:attendance][:groups_id])
            if is_max_tardies(ug, params[:attendance][:event])
               @att = Attendance.create(:absent => true, :absence_tardy => true, :user_id => ug.id, :tracker_id => current_user.id, :date_recorded => Time.now.strftime("%D"), :event => params[:attendance][:event], :groups_id => params[:attendance][:groups_id])
            end
          end
        else
          if @tardy_users.include?(ug)
          else
            Attendance.find_by(:tardy => true, :absence_tardy => nil, :user_id => ug.id, :event => params[:attendance][:event], :date_recorded => Time.now.strftime("%D")).destroy
            if is_max_tardies(ug, params[:attendance][:event]) == false 
                @att = Attendance.find_by(:absence_tardy => true, :user_id => ug.id, :event => params[:attendance][:event]) rescue nil
                if @att != nil
                  @att.destroy
                end
            end
          end  
        end
      end   
    else
      users_in_group(params[:attendance][:groups_id]).each do |ug|
        @att = Attendance.find_by(:tardy => true, :user_id => ug.id, :event => params[:attendance][:event], :date_recorded => Time.now.strftime("%D")) rescue nil
        if @att != nil
          @att.destroy 
        end
        if is_max_tardies(ug, params[:attendance][:event]) == false 
           @att = Attendance.find_by(:absence_tardy => true, :user_id => ug.id, :event => params[:attendance][:event]) rescue nil
           if @att != nil
             @att.destroy
           end
        end
      end
     
    end
    end
    
    
    respond_to do |format|
        format.html { redirect_to groups_path, notice: 'Attendance  successfully recorded.' }
        format.mobile{ redirect_to groups_path, notice: 'Attendance was successfully recorded.' }
        format.json { render action: 'show', status: :created, location: @attendance }
    end

  end
  
#if group was deleted assigns groupless attendance records to some other group
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
  
  #Inserts attendance if tardy limit reaches of event limit tarcy absence automatically gets added
  def process_insert_attendance
        @users = User.find(params[:project][:user_ids]) rescue nil
        @event = Event.find_by_id(params[:event])
        @offence = params[:offence].to_s
        if params[:date] != ""
          @date = Date.strptime(params[:date],"%m/%d/%Y").strftime("%D")
        else
          @date = ""
        end
        @group = Group.find_by_id(params[:id])
        if @users != nil && @date != ""
        @users.each do |user|
          if @offence == "Absence"
             @att = Attendance.create(:absent => true, :user_id => user.id, :tracker_id => current_user.id, :date_recorded => Time.now.strftime("%D"), :event => @event.event_name, :groups_id => @group.id)
          elsif @offence == "Tardy"  
             @att = Attendance.create(:tardy => true, :user_id => user.id, :tracker_id => current_user.id, :date_recorded => Time.now.strftime("%D"), :event => @event.event_name, :groups_id => @group.id)
          elsif @offence == "Tardy limit absence"  
             @att = Attendance.create(:absent => true, :absence_tardy => true, :user_id => user.id, :tracker_id => current_user.id, :date_recorded => Time.now.strftime("%D"), :event => @event.event_name, :groups_id => @group.id)
          end
        end
        end
        respond_to do |format|
          if @users != nil && @date != ""
            format.html{redirect_to attendances_path(:attgroup_id => @group.id), notice: "Attendance successfully inserted"}
          else
            format.html{redirect_to attendances_path(:attgroup_id => @group.id), alert: "No changes were made. No users were selected or something went wrong. Please try again."}
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
  
  def is_max_tardies (user, event)
    @tardies = Attendance.where(:user_id => user.id, :tardy => true, :event => event) rescue nil
    @max_tardies =  Event.find_by_event_name(params[:attendance][:event]).max_tardies rescue nil
    if @tardies != nil && @max_tardies != nil
      if @tardies.count % @max_tardies == 0
       return true
      else
        return false
      end
    end
    return false
  end
  
  def attendance_params
    params.require(:attendance).permit(:event, :absent, :tardy, :user_id, :user_ids, :tracker_id, :groups_id, :absence_tardy, :offence)
  end

end
