module GroupsHelper
  def today(group) #Script that determines if today is one of the days attendance is allowed to be taken on
    @availabledays = (group.ptdays+group.llabdays).split("-")
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

  def not_assigned_to_attendance_group
    @notin = Array.new
    User.all.each do |u|
      if u.in_attendance_group == false || u.in_attendance_group == nil
      @notin << u
      end
    end
    return @notin

  end

  

end
