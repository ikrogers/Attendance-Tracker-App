module AttendancesHelper 
  
   def is_today_excused_pt(user)
    @user = User.find_by_id(user.id)
    @availabledays = @user.excused_pt_days.split("::")
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
    @user = User.find_by_id(user.id)
    @availabledays = @user.excused_llab_days.split("::")
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
