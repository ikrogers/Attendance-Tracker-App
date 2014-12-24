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

  def is_today_pt(group)
    group = Group.find_by_id(group)
    @availabledays = group.ptdays.split("::")
    @flag = false
    @availabledays.each do |a|
      if Time.now.strftime("%A") == a
        @flag = true
      break
      else
        @flag = false
      end
    end
    return @flag
  end

  def is_today_llab(group)
    group = Group.find_by_id(group)
    @availabledays = group.llabdays.split("::")
    @flag = false
    @availabledays.each do |a|
      if Time.now.strftime("%A") == a
        @flag = true
      break
      else
        @flag = false
      end
    end
    return @flag
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

  def groups_present
    @groups = Group.all rescue nil
    if @groups == nil
      return false
    else
      return true
    end
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
        @allowed << @e.event_name
        end

      end
    end
    return @allowed
  end


end
