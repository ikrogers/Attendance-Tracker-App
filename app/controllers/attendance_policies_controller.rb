class AttendancePoliciesController < InheritedResources::Base
    before_action :authenticate_user!
    layout 'application1'

  
  
  
  
  
  
  
  
   def attendance_policy_params
    params.require(:attendance_policy).permit(:message, :absence_milestone, :action, :event, :groups_id )
  end
  
end
