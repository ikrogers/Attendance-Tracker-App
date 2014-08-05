module GroupsHelper
  
   def today(group) #Script that determines if today is one of the days attendance is allowed to be taken on
    @availabledays = (group.ptdays+group.llabdays).split("::")
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
    @attendance = Group.where(grouptype: "Attendance")
    @users = User.all
    @users_not_in_attendance = Array.new
    @allusers = Array.new
    @attendance.each do |a|
      @ingroups = InGroup.where(groups_id: a.id)
      @ingroup.each do |ig|
        @allusers << ig.users_id
      end
    end
    @allusers.uniq!
    @users.each do |u|
      @flag = false
      @allusers.each do |au|
        if au != u.id
          @users_not_in_attendance << u
          break
        end
      end
    end
    return @users_not_in_attendance
    
  end
  
end
