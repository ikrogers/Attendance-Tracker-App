class InGroupsController < InheritedResources::Base
  before_action :authenticate_user!
    layout 'application1'

  before_action :set_group, :only => [:show_members]
  
  def show_members
   
  end
  
  
  def group_params
    params.require(:in_group).permit(:name, :user_id, :groups_id)
  end
  private
    def show_members
      @group_id = params[:group_id]
    end
end
