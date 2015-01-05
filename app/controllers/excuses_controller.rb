class ExcusesController < InheritedResources::Base

  before_action :authenticate_user!
  layout 'application1'
  def create
    @excuse = Excuse.create(excuse_params)
    respond_to do |format|
      if @excuse.save
        format.html { redirect_to excuses_path, notice: 'Excuse was successfully created.' }
        format.mobile{ redirect_to excuses_path, notice: 'Excuse was successfully created.' }
        format.json { render action: 'show', status: :created, location: @excuse }
      else
        format.html { render action: 'new' }
        format.mobile { render action: 'new' }
        format.json { render json: @excuse.errors, status: :unprocessable_entity }
      end
    end

  end
  
  def update
    @excuse = Excuse.find_by_id(params[:id])
    respond_to do |format|
      if @excuse.update(excuse_params)
        format.html { redirect_to excuses_path, notice: 'Excuse was successfully updated.' }
        format.mobile{ redirect_to excuses_path, notice: 'Excuse was successfully updated.' }
        format.json { render action: 'show', status: :created, location: @excuse }
      else
        format.html { render action: 'new' }
        format.mobile { render action: 'new' }
        format.json { render json: @excuse.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @excuse = Excuse.find(params[:id])
    @groups = Group.all
    @groups.each do |group|
      if group.grouptype.include? @excuse.event
        @in_group = InGroup.where(:groups_id => group.id, :users_id => @excuse.user_id) rescue nil
        if @in_group != nil
          @in_group.destroy_all
          break
        end
      end
    end
    @excuse.destroy
    respond_to do |format|
      format.html { redirect_to excuses_path, notice: 'Excuse removed! All associated records has been removed as well' }
    end
  end
private


  def excuse_params
    params.require(:excuse).permit(:user_id, :event, :timeframe, :excused_days => [])
  end

end 