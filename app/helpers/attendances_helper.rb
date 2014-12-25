module AttendancesHelper
  def users_in_group(group)
  @group=Group.find_by_id(group)
      @ingroup = InGroup.where(groups_id: @group.id)      
      @usersingroup= Array.new
      @ingroup.each do |ig|
        @usersingroup << User.find_by_id(ig.users_id)
      end
  return @usersingroup
  end
end
