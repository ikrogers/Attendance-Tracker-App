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


end
