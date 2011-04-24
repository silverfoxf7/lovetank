class WinationshipsController < ApplicationController
#  before_filter :authenticate

  def create
    # raise params.inspect -- used to inspect
    @job = Jobpost.find(params[:winationship][:job_id])
    @winner = User.find(params[:winationship][:worker_id])
     # the [x][y] is pulling out the id from the nested hash
    @job.pick_winner!(@winner)
    respond_to do |format|
      format.html { redirect_to jobpost_path(@job) }
      format.js
    end
    # used to incorporate AJAX
  end

  def destroy
#    @user = Relationship.find(params[:id]).followed
    @job = Jobpost.find(params[:winationship][:job_id])
    @loser = User.find(params[:winationship][:worker_id])
    @job.pick_loser!(@loser)
    respond_to do |format|
      format.html { redirect_to jobpost_path(@job) }
      format.js
    end
  end
end

#  def winner?(worker)
#  def pick_winner!(worker)
#  def pick_loser!(worker)
