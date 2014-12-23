module AttendancePoliciesHelper
  def group_exists(id)
    @flag =  Group.find_by_id(id) rescue nil
    if @flag != nil
      return @flag.name
    else
      return "All Groups"
    end
  end
end
