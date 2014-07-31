class ExcusedUsersController < InheritedResources::Base
  
  
  
  
  
  
  
  
  
  def attendance_params
    params.require(:excused_user).permit(:users_id, :groups_id, :excused_pt, :excused_pt_day, :excused_llab, :excused_llab_day)
  end
end
