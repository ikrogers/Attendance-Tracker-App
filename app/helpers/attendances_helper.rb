module AttendancesHelper
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
