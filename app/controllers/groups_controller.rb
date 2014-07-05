class GroupsController < InheritedResources::Base
  def create
    @group = Group.new(group_params)

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

  def update
    @group= Group.find params[:id]

    respond_to do |format|
      @users = User.find(params[:project][:user_ids]) rescue []

      @users.each do |u|
        @in_group = InGroup.new

        @in_group.update_attributes(:groups_id => @group.id)
        @in_group.update_attributes(:users_id => u.id)
      end
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def group_params
    params.require(:group).permit(:name)
  end
end
