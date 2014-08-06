class AlternateController < ApplicationController
  before_action :authenticate_user!
  layout 'application1'
  def new
    @users = User.all
  end

  def create
    @ptdays = params[:project][:excused_pt_days] rescue nil
    @llabdays = params[:project][:excused_llab_days] rescue nil
    @users = User.find(params[:project][:user_ids]) rescue nil
    @processaction = params[:project][:add_remove] rescue nil

    if @processaction[0] == "Add PT Excuse"
      if @ptdays != nil
        @users.each do |user|
          @ptday_string = ''
          @ptdays.each do |d|
            @ptday_string = @ptday_string+'::'+d
            user.update_attributes(:excused_pt_days => @ptday_string, :ptexcuse => true)
          end
        end
      end
    elsif @processaction[0] == "Add LLAB Excuse"
      if @llabdays != nil

        @users.each do |user|
          @llabday_string = ''
          @llabdays.each do |d|
            @llabday_string = @llabday_string+'::'+d
            user.update_attributes(:excused_llab_days => @llabday_string, :llabexcuse => true)
          end
        end
      end
    elsif @processaction[0] == "Add LLAB and PT Excuse"
      if @ptdays != nil

        @users.each do |user|
          @ptday_string = ''
          @ptdays.each do |d|
            @ptday_string = @ptday_string+'::'+d
            user.update_attributes(:excused_pt_days => @ptday_string, :ptexcuse => true)
          end
        end
      end
      if @llabdays != nil

        @users.each do |user|
          @llabday_string = ''
          @llabdays.each do |d|
            @llabday_string = @llabday_string+'::'+d
            user.update_attributes(:excused_llab_days => @llabday_string, :llabexcuse => true)
          end
        end
      end
    end
    if @users == nil
      respond_to do |format|
        format.html{redirect_to excused_users_path, alert: 'Nothing was updated. You may have forgotten to select some users on the previous page!'}
      end
    else
      respond_to do |format|
        format.html{redirect_to excused_users_path, notice: 'Users have been successfully added/updated. You may now add them to alternate PT or LLAB groups for attendance tracking!'}
      end
    end
  end

  def index

  end

  def remove_pt_excuse
    @user = User.find_by_id(params[:id])
    @user.update_attributes(:excused_pt_days => nil, :ptexcuse => false)
    respond_to do |format|
      format.html{redirect_to excused_users_path, notice: 'PT excuse removed successfully! User will now appear on all regular attendance tracking forms'}
    end
  end

  def remove_llab_excuse
    @user = User.find_by_id(params[:id])
    @user.update_attributes(:excused_llab_days => nil, :llabexcuse => false)
    respond_to do |format|
      format.html{redirect_to excused_users_path, notice: 'LLAB excuse removed successfully! User will now appear on all regular attendance tracking forms'}
    end
  end
end
