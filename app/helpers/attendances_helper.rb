module AttendancesHelper
  def users_in_group_excused_excluded(group, event)
    @group=Group.find_by_id(group)
    @ingroup = InGroup.where(groups_id: @group.id)
    @usersingroup = Array.new
    @ingroup.each do |ig|
      @usersingroup << User.find_by_id(ig.users_id)
    end
    @excused_list = Array.new
    @usersingroup.each do |ig|
      @excuse = Excuse.find_by(:user_id => ig.id, :event => event) rescue nil
      if @excuse != nil
        if @excuse.excused_days.include?(Time.now.strftime("%A"))
        else
        @excused_list << ig
        end
      else
      @excused_list << ig
      end
    end
    return @excused_list
  end


  def users_in_group_unfiltered(group)
    @group=Group.find_by_id(group)
    @ingroup = InGroup.where(groups_id: @group.id)
    @usersingroup = Array.new
    @ingroup.each do |ig|
      @usersingroup << User.find_by_id(ig.users_id)
    end
    return @usersingroup
  end

end
