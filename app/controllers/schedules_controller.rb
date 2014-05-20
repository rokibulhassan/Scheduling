class SchedulesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_schedule, only: [:show, :edit, :update, :destroy, :tweet]

  # GET /schedules
  # GET /schedules.json
  def index
    @schedules = current_user.schedules.not_tweet rescue []
  end

  # GET /schedules/1
  # GET /schedules/1.json
  def show
  end

  # GET /schedules/new
  def new
    @schedule = Schedule.new
  end

  # GET /schedules/1/edit
  def edit
  end

  # POST /schedules
  # POST /schedules.json
  def create
    @schedule = Schedule.new(schedule_params)
    @schedule.user = current_user

    respond_to do |format|
      if @schedule.save
        format.html { redirect_to @schedule, notice: 'Schedule was successfully created.' }
        format.json { render :show, status: :created, location: @schedule }
      else
        format.html { render :new }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /schedules/1
  # PATCH/PUT /schedules/1.json
  def update
    respond_to do |format|
      if @schedule.update(schedule_params)
        format.html { redirect_to @schedule, notice: 'Schedule was successfully updated.' }
        format.json { render :show, status: :ok, location: @schedule }
      else
        format.html { render :edit }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  def upload_schedules
    begin
      Schedule.import(params[:file], current_user)
      flash[:notice] = 'Successfuly uploaded schedules.'
    rescue Exception => ex
      flash[:error] = ex.message
    end
    redirect_to schedules_path
  end

  def tweet
    begin
      Schedule.tweet(@schedule.twitter_id, @schedule.tweet, @schedule.image_url)
      @schedule.update_attributes!(status: true)
      flash[:notice] = 'Tweeted on twitter successfully.'
    rescue Exception => ex
      flash[:error] = ex.message
    end
    redirect_to schedules_path
  end

  # DELETE /schedules/1
  # DELETE /schedules/1.json
  def destroy
    @schedule.destroy
    respond_to do |format|
      format.html { redirect_to schedules_url, notice: 'Schedule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_schedule
    @schedule = Schedule.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def schedule_params
    params.require(:schedule).permit(:tweet_at, :twitter_id, :tweet, :image_url, :user_id)
  end
end
