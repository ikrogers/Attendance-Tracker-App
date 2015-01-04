module ApplicationHelper
  def any_errors(resource, field)
    return nil if resource.errors[field] == nil
    messages = resource.errors.full_messages_for(field).map { |msg| content_tag(:li, msg) }.join
    if resource.errors.full_messages_for(field) != []
      html = <<-HTML
    <div class="alert alert-error alert-block"> <button type="button"
    class="close" data-dismiss="alert">x</button>
      #{messages}
    </div>
    HTML

    html.html_safe
    else
      return nil
    end
  end

  def is_today_alt(group)
    @days = group.alt_event_days
    if @days != nil
      @days.each do |ed|
        if Time.now.strftime("%A") == ed
        return true
        end
      end
    end
    return false
  end

  def get_events
    @event_objs = Event.all rescue nil
    @events = Array.new
    if @event_objs != nil
      @event_objs.each do |e|
        @events << e.event_name
      end
    end
    return @events
  end

  def assigned_events(group_id)
    @policy = AttendancePolicy.where(:groups_id => group_id)
    @policy_all = AttendancePolicy.where(:groups_id => nil)

    @events = Array.new
    @allowed = Array.new
    @policy.each do |p|
      @events << p.event
    end
    @policy_all.each do |p|
      @events << p.event
    end
    @events.uniq().each do |e|
      @e = Event.find_by_event_name(e)
      if @e.event_days != nil
        @e.event_days.each do |ed|
          if Time.now.strftime("%A") == ed
            @flag = true
          break
          else
            @flag = false
          end
        end
        if @flag == true
        @allowed << @e
        end
      end
    end
    return @allowed
  end

  def populate_new_groups
    @names = Array.new
    @names << "Attendance"
    @names << "Non-Attendance"
    @group = Group.all
    if @group.count >= 1
      Event.all.each do |event|
        if alt_name_exist(event) == false
          @names << "Alternate "+ event.event_name+" Attendance"
        end
      end
    else
      Event.all.each do |event|
        @names << "Alternate "+ event.event_name+" Attendance"
      end
    end
    return @names
  end

  def alt_name_exist(event)
    @group = Group.all
    @group.each do |group|
      if (group.grouptype.include? event.event_name)
      return true
      end
    end
    return false
  end

  def get_users_for_group(group)
    @users = Array.new
    InGroup.where(:groups_id => group).each do |g|
      @users << User.find(g.users_id)
    end
    return @users
  end

  def get_absence_events(user)
    @events = Array.new
    Attendance.where(:user_id => user.id, :absent => true).each do |event|
      @event = Event.find_by_event_name(event.event)
      @events << @event.event_name
    end
    return @events.uniq
  end

  def get_tardy_events(user)
    @events = Array.new
    Attendance.where(:user_id => user.id, :tardy => true).each do |event|
      @event = Event.find_by_event_name(event.event)
      @events << @event.event_name
    end
    return @events.uniq
  end

  def get_absence_count(user, event)
    return Attendance.where(:user_id => user.id, :absent => true, :event => event).count
  end

  def get_tardy_count(user, event)
    return Attendance.where(:user_id => user.id, :tardy => true, :event => event).count
  end

  def get_absence_days(user, event)
    @days = Array.new
    Attendance.where(:user_id => user.id, :absent => true, :event => event).each do |att|
      if att.absence_tardy != nil && att.absence_tardy == true
        @days << Date.strptime(att.date_recorded,"%m/%d/%y").to_date.to_formatted_s("%M/%d/%Y").to_date.to_formatted_s(:long)+" (Absence due to reaching tardy limit)"
      else
        @days << Date.strptime(att.date_recorded,"%m/%d/%y").to_date.to_formatted_s("%M/%d/%Y").to_date.to_formatted_s(:long)
      end
    end
    return @days
  end

  def get_tardy_days(user, event)
    @days = Array.new
    Attendance.where(:user_id => user.id, :tardy => true, :event => event).each do |att|
      @days << Date.strptime(att.date_recorded,"%m/%d/%y").to_date.to_formatted_s("%M/%d/%Y").to_date.to_formatted_s(:long)
    end
    return @days
  end

end
