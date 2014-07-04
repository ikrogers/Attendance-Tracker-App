class GroupsController < InheritedResources::Base

  
 def create
    @group = Group.new(group_params)
    users = User.find(params[:project][:user_ids]) rescue []
    @users = users
    @users.each do |u|
      @g = Group.new(:name => u.email)
      @g.save
    end
    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.js
        format.json { render action: 'show', status: :created, location: @group }
      else
        format.html { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  
  
  def group_params
    params.require(:group).permit(:name)
  end
end
