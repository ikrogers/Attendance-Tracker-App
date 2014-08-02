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
  
end
