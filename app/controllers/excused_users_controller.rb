class ExcusedUsersController < InheritedResources::Base
  before_action :authenticate_user!
  layout 'application1'
  def create
    @llabusers = params[:project][:pt_user_ids] rescue nil
    @ptusers = params[:project][:llab_user_ids] rescue nil
   

    respond_to do |format|
      if @excused.save
        format.html { redirect_to groups_path, alert: 'Stop trying to hack amateur!' }
        format.mobile { redirect_to groups_path, alert: 'Stop trying to hack amateur!' }
      else
        format.html { redirect_to groups_path, notice: 'Attendance recorded successfully!' }
        format.mobile { redirect_to groups_path, notice: 'Attendance recorded successfully!' }

      end
    end
  end

  def excused_user_params
    params.require(:excused_user).permit(:users_id, :groups_id, :excused_pt, :excused_pt_day, :excused_llab, :excused_llab_day)
  end
end

