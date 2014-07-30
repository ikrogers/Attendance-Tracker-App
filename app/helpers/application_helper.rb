module ApplicationHelper
    
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
  

  
  
end
