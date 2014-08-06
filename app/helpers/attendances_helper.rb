module AttendancesHelper 
  
   def is_today_excused_pt(user)
    @user = User.find_by_id(group)
    @availabledays = @user.ptdays.split("::")
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
  
   def is_today_excused_llab(user)
    @user = User.find_by_id(group)
    @availabledays = @user.ptdays.split("::")
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
 
  
  
  
end
