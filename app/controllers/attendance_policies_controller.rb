class AttendancePoliciesController < InheritedResources::Base
  before_action :authenticate_user!
  layout 'application1'
  def create
    @attendance_policy = AttendancePolicy.create(attendance_policy_params)
    
    respond_to do |format|
      if @attendance_policy.save
        format.html { redirect_to attendance_policies_path, notice: 'Rule was successfully created.' }
        format.mobile{ redirect_to attendance_policies_path, notice: 'Rule was successfully created.' }
        format.js
        format.json { render action: 'show', status: :created, location: @attendance_policy }
      else
        format.html { render action: 'new' }
        format.mobile { render action: 'new' }
        format.json { render json: @attendance_policy.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @attendance_policy = AttendancePolicy.find_by_id(params[:id])
    respond_to do |format|
      if @attendance_policy.update(attendance_policy_params)
        format.html { redirect_to attendance_policies_path, notice: 'Rule was successfully updated.' }
        format.mobile{ redirect_to attendance_policies_path, notice: 'Rule was successfully updated.' }
        format.js
        format.json { render action: 'show', status: :created, location: @attendance_policy }
      else
        format.html { render action: 'new' }
        format.mobile { render action: 'new' }
        format.json { render json: @attendance_policy.errors, status: :unprocessable_entity }
      end
    end
  end
private
  def attendance_policy_params
    params.require(:attendance_policy).permit(:message, :absence_milestone, :action, :event, :groups_id, :additional_users => [] )
  end

end
