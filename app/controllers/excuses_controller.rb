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
private


  def excuse_params
    params.require(:excuse).permit(:user_id, :event, :timeframe, :excused_days => [])
  end

end 