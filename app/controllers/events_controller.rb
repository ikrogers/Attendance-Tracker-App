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
        format.js
        format.json { render action: 'show', status: :created, location: @group }
      else
        format.html { render action: 'new' }
        format.mobile { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
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

  private

  def event_params
    params.require(:event).permit(:event_name, :absence_max)
  end
end

