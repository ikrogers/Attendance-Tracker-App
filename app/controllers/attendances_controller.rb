class AttendancesController < InheritedResources::Base
  before_action :authenticate_user!
  layout 'application1'
  def create
    @absent_users = User.find(params[:project][:absent_user_ids]) rescue nil
    @tardy_users = User.find(params[:project][:tardy_user_ids]) rescue nil

    if @absent_users != nil
      users_in_group(params[:attendance][:groups_id]).each do |ug|
        if Attendance.find_by(:absent => true, :absence_tardy => nil, :user_id => ug.id, :event => params[:attendance][:event], :date_recorded => Time.now.strftime("%D")).nil?
          if @absent_users.include?(ug)
            @att = Attendance.create(:absent => true, :user_id => ug.id, :tracker_id => current_user.id, :date_recorded => Time.now.strftime("%D"), :event => params[:attendance][:event], :groups_id => params[:attendance][:groups_id])
            absence_notify(ug, params[:attendance][:event], "ABSENCE ADD")
          end
        else
          if @absent_users.include?(ug)
            else
            Attendance.find_by(:absent => true, :absence_tardy => nil, :user_id => ug.id, :event => params[:attendance][:event], :date_recorded => Time.now.strftime("%D")).destroy
            absence_notify(ug, params[:attendance][:event], "ABSENCE REMOVE")
          end
        end
      end
    else
      users_in_group(params[:attendance][:groups_id]).each do |ug|
        @att = Attendance.find_by(:absent => true, :absence_tardy => nil, :user_id => ug.id, :event => params[:attendance][:event], :date_recorded => Time.now.strftime("%D")) rescue nil
        if @att != nil
          @att.destroy
          absence_notify(ug, params[:attendance][:event], "ABSENCE REMOVE")

        end
      end
    end

    if Event.find_by_event_name(params[:attendance][:event]).max_tardies != nil
      if @tardy_users != nil
        users_in_group(params[:attendance][:groups_id]).each do |ug|
          if Attendance.find_by(:tardy => true, :absence_tardy => nil, :user_id => ug.id, :event => params[:attendance][:event], :date_recorded => Time.now.strftime("%D")).nil?
            if @tardy_users.include?(ug)
              @att = Attendance.create(:tardy => true, :user_id => ug.id, :tracker_id => current_user.id, :date_recorded => Time.now.strftime("%D"), :event => params[:attendance][:event], :groups_id => params[:attendance][:groups_id])
              tardy_notify(ug, params[:attendance][:event], "TARDY ADD")
              if is_max_tardies(ug, params[:attendance][:event])
                @att = Attendance.create(:absent => true, :absence_tardy => true, :user_id => ug.id, :tracker_id => current_user.id, :date_recorded => Time.now.strftime("%D"), :event => params[:attendance][:event], :groups_id => params[:attendance][:groups_id])
                max_tardy_notify(ug, @event.event_name, "TARDY ABSENCE ADD")
              end
            end
          else
            if @tardy_users.include?(ug)
              else
              Attendance.find_by(:tardy => true, :absence_tardy => nil, :user_id => ug.id, :event => params[:attendance][:event], :date_recorded => Time.now.strftime("%D")).destroy
              tardy_notify(ug, params[:attendance][:event], "TARDY REMOVE")
              if is_max_tardies(ug, params[:attendance][:event]) == false
                @att = Attendance.find_by(:absence_tardy => true, :user_id => ug.id, :event => params[:attendance][:event]) rescue nil
                if @att != nil
                  max_tardy_notify(ug, @event.event_name, "TARDY ABSENCE REMOVE")
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
            tardy_notify(ug, params[:attendance][:event], "TARDY REMOVE")
          end
          if is_max_tardies(ug, params[:attendance][:event]) == false
            @att = Attendance.find_by(:absence_tardy => true, :user_id => ug.id, :event => params[:attendance][:event]) rescue nil
            if @att != nil
            max_tardy_notify(ug, @event.event_name, "TARDY ABSENCE REMOVE")
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
        if @offence == "Absent"
          @att = Attendance.create(:absent => true, :user_id => user.id, :tracker_id => current_user.id, :date_recorded => @date, :event => @event.event_name, :groups_id => @group.id)
          absence_notify(user, @event.event_name, "ABSENCE ADD")
        elsif @offence == "Tardy"
          @att = Attendance.create(:tardy => true, :user_id => user.id, :tracker_id => current_user.id, :date_recorded => @date, :event => @event.event_name, :groups_id => @group.id)
          tardy_notify(user, @event.event_name, "TARDY ADD")
        elsif @offence == "Tardy limit absence"
          @att = Attendance.create(:absent => true, :absence_tardy => true, :user_id => user.id, :tracker_id => current_user.id, :date_recorded => @date, :event => @event.event_name, :groups_id => @group.id)
          max_tardy_notify(user, @event.event_name, "TARDY ABSENCE ADD")
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
      if @attendance.absent == true
        absence_notify(User.find(@attendance.user_id), @attendance.event, "ABSENCE REMOVE")
      elsif @attendance.tardy == true
        tardy_notify(User.find(@attendance.user_id), @attendance.event, "TARDY REMOVE")
      elsif @attendance.absent == true && @attendance.absence_tardy == true
        max_tardy_notify(user, @event.event_name, "TARDY ABSENCE REMOVE")
      end
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

  def absence_notify(user, event, action)
    @carrier = {"Verizon"=>"@vtext.com", "AT&T"=>"@txt.att.net","Boost Mobile" => "@myboostmobile.com", "Cellular One"=>"@mobile.celloneusa.com","Metro PCS"=>"@mymetropcs.com","Nextel"=>"@messaging.nextel.com","Sprint"=>"@messaging.sprintpcs.com","T-Mobile"=>"@tmomail.net","Tracfone"=>"@txt.att.net"}
    @event = Event.find_by_event_name(event)
    if action == "ABSENCE ADD"
      if @event.notification_type == "SMS"
        UserMailer.absence_notify_text(user, [user.phone, @carrier[user.carrier]].join(""), event).deliver
      elsif @event.notification_type == "E-Mail"
        UserMailer.absence_notify(user, event).deliver
      elsif @event.notification_type == "Both"
        UserMailer.absence_notify(user, event).deliver
        UserMailer.absence_notify_text(user, [user.phone, @carrier[user.carrier]].join(""), event).deliver
      else
      end
    elsif action == "ABSENCE REMOVE"
      if @event.notification_type == "SMS"
        UserMailer.absence_removed_notify_text(user, [user.phone, @carrier[user.carrier]].join(""), event).deliver
      elsif @event.notification_type == "E-Mail"
        UserMailer.absence_removed_notify(user, event).deliver
      elsif @event.notification_type == "Both"
        UserMailer.absence_removed_notify(user, event).deliver
        UserMailer.absence_removed_notify_text(user, [user.phone, @carrier[user.carrier]].join(""), event).deliver
      else
      end
    elsif action == "TARDY ABSENCE ADD"
      if @event.notification_type == "SMS"
        UserMailer.absence_removed_notify_text(user, [user.phone, @carrier[user.carrier]].join(""), event).deliver
      elsif @event.notification_type == "E-Mail"
        UserMailer.absence_removed_notify(user, event).deliver
      elsif @event.notification_type == "Both"
        UserMailer.absence_removed_notify(user, event).deliver
        UserMailer.absence_removed_notify_text(user, [user.phone, @carrier[user.carrier]].join(""), event).deliver
      else
      end
    elsif action == "TARDY ABSENCE REMOVE"
      if @event.notification_type == "SMS"
        UserMailer.absence_removed_notify_text(user, [user.phone, @carrier[user.carrier]].join(""), event).deliver
      elsif @event.notification_type == "E-Mail"
        UserMailer.absence_removed_notify(user, event).deliver
      elsif @event.notification_type == "Both"
        UserMailer.absence_removed_notify(user, event).deliver
        UserMailer.absence_removed_notify_text(user, [user.phone, @carrier[user.carrier]].join(""), event).deliver
      else
      end
    end
  end

  def tardy_notify(user, event, action)
    @carrier = {"Verizon"=>"@vtext.com", "AT&T"=>"@txt.att.net","Boost Mobile" => "@myboostmobile.com", "Cellular One"=>"@mobile.celloneusa.com","Metro PCS"=>"@mymetropcs.com","Nextel"=>"@messaging.nextel.com","Sprint"=>"@messaging.sprintpcs.com","T-Mobile"=>"@tmomail.net","Tracfone"=>"@txt.att.net"}
    @event = Event.find_by_event_name(event)
    if action == "TARDY ADD"
      if @event.notification_type == "SMS"
        UserMailer.tardy_notify_text(user, [user.phone, @carrier[user.carrier]].join(""), event).deliver
      elsif @event.notification_type == "E-Mail"
        UserMailer.tardy_notify(user, event).deliver
      elsif @event.notification_type == "Both"
        UserMailer.tardy_notify(user, event).deliver
        UserMailer.tardy_notify_text(user, [user.phone, @carrier[user.carrier]].join(""), event).deliver
      else
      end
    elsif action == "TARDY REMOVE"
      if @event.notification_type == "SMS"
        UserMailer.tardy_removed_notify_text(user, [user.phone, @carrier[user.carrier]].join(""), event).deliver
      elsif @event.notification_type == "E-Mail"
        UserMailer.tardy_removed_notify(user, event).deliver
      elsif @event.notification_type == "Both"
        UserMailer.tardy_removed_notify(user, event).deliver
        UserMailer.tardy_removed_notify_text(user, [user.phone, @carrier[user.carrier]].join(""), event).deliver
      else
      end
    end
  end

  def max_tardy_notify(user, event, action)
    @carrier = {"Verizon"=>"@vtext.com", "AT&T"=>"@txt.att.net","Boost Mobile" => "@myboostmobile.com", "Cellular One"=>"@mobile.celloneusa.com","Metro PCS"=>"@mymetropcs.com","Nextel"=>"@messaging.nextel.com","Sprint"=>"@messaging.sprintpcs.com","T-Mobile"=>"@tmomail.net","Tracfone"=>"@txt.att.net"}
    @event = Event.find_by_event_name(event)
    if action == "TARDY ABSENCE ADD"
      if @event.notification_type == "SMS"
        UserMailer.max_tardy_notify_text(user, [user.phone, @carrier[user.carrier]].join(""), event).deliver
      elsif @event.notification_type == "E-Mail"
        UserMailer.max_tardy_notify(user, event).deliver
      elsif @event.notification_type == "Both"
        UserMailer.max_tardy_notify(user, event).deliver
        UserMailer.max_tardy_notify_text(user, [user.phone, @carrier[user.carrier]].join(""), event).deliver
      else
      end
    elsif action == "TARDY ABSENCE REMOVE"
      if @event.notification_type == "SMS"
        UserMailer.max_tardy_removed_notify_text(user, [user.phone, @carrier[user.carrier]].join(""), event).deliver
      elsif @event.notification_type == "E-Mail"
        UserMailer.max_tardy_removed_notify(user, event).deliver
      elsif @event.notification_type == "Both"
        UserMailer.max_tardy_removed_notify(user, event).deliver
        UserMailer.max_tardy_removed_notify_text(user, [user.phone, @carrier[user.carrier]].join(""), event).deliver
      else
      end
    end
  end

  def attendance_params
    params.require(:attendance).permit(:event, :absent, :tardy, :user_id, :user_ids, :tracker_id, :groups_id, :absence_tardy, :offence)
  end

end
