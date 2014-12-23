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

end
