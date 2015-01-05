class EventsController < InheritedResources::Base
  before_action :authenticate_user!
  layout 'application1'
  def new
    @event = Event.new
  end

  def create
    @event = Event.create(event_params)
    respond_to do |format|
      if @event.save
        format.html { redirect_to events_path, notice: 'Event was successfully created.' }
        format.mobile{ redirect_to events_path, notice: 'Event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @event }
      else
        format.html { render action: 'new' }
        format.mobile { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end

  end

  def index
    @events = Event.all
  end

  def edit
    @event = Event.find_by_id(params[:id])
  end

  def update
    
    @event = Event.find_by_id(params[:id])
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to events_path, notice: 'Event was successfully updated.' }
        format.mobile{ redirect_to events_path, notice: 'Event was successfully updated.' }
        format.js
        format.json { render action: 'show', status: :created, location: @group }
      else
        format.html { render action: 'new' }
        format.mobile { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @event = Event.find(params[:id])
    @groups = Group.all
    @groups.each do |group|
      if group.grouptype.include? @event.event_name
        @in_group = InGroup.where(:groups_id => group.id) rescue nil
        if @in_group != nil
          @in_group.destroy_all
        end
        group.destroy
      end
    end
    
    @excuses = Excuse.where(:event => @event.event_name) rescue nil
    if @excuses != nil
      @excuses.destroy_all
    end
    
    @policies = AttendancePolicy.where(:event => @event.event_name) rescue nil
    if @policies != nil
      @policies.destroy_all
    end
    
    @event.destroy
    
    respond_to do |format|
      format.html { redirect_to events_path, notice: 'Event removed! All associated records has been removed as well' }
    end
  end

  private

  def event_params
    params.require(:event).permit(:event_name, :absence_max, :max_tardies, :notification_type, :event_days => [])
  end
end

