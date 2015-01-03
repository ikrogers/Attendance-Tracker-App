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
  
  def strip_alt_att(group)
    @name = group.remove("Alternate ")
    @name = @name.remove(" Attendance")
    return @name
  end

  def excused_group(group)
    @group = Group.find_by_id(group)
    @excused = Array.new
    @name = @group.grouptype.remove("Alternate ")
    @name = @name.remove(" Attendance")
    @excuse = Excuse.where(:event => @name) rescue nil
    if @excuse != nil
      @excuse.each do |ex|
        @excused << User.find_by_id(ex.user_id)
      end
    end
    return @excused
  end

  def users_in_group(group)

    @group = Group.find group
    @ingroup = InGroup.where(groups_id: @group.id)
    @users = User.all
    @usersnotingroup = Array.new
    @users.each do |u|
      @notin = InGroup.find_by(users_id: u.id, groups_id: @group.id) rescue nil
      if @notin == nil
        @usersnotingroup << User.find_by_id(u.id)
      end
    end
    @usersingroup= Array.new
    @ingroup.each do |ig|
      @usersingroup << User.find_by_id(ig.users_id)
    end
    return @usersingroup

  end

  def users_not_in_group(group)
    @group = Group.find group
    @ingroup = InGroup.where(groups_id: @group.id)
    @users = User.all
    @usersnotingroup = Array.new
    @users.each do |u|
      @notin = InGroup.find_by(users_id: u.id, groups_id: @group.id) rescue nil
      if @notin == nil
        @usersnotingroup << User.find_by_id(u.id)
      end
    end
    @usersingroup= Array.new
    @ingroup.each do |ig|
      @usersingroup << User.find_by_id(ig.users_id)
    end
    return @usersnotingroup
  end

end
