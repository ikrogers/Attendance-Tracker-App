class AlternateController < ApplicationController
  before_action :authenticate_user!
  layout 'application1'
  def new
    @users = User.all
  end

  def create
    @ptdays = params[:project][:ptdays] rescue nil
    @llabdays = params[:project][:llabdays] rescue nil
    @users = User.find(params[:project][:user_ids]) rescue nil
    @processaction = params[:project][:processaction] rescue nil


  end

  def index

  end

end
