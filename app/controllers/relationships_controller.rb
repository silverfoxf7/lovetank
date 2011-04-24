class RelationshipsController < ApplicationController
  before_filter :authenticate

  def create
    # raise params.inspect -- used to inspect
    @user = User.find(params[:relationship][:followed_id])
     # the [x][y] is pulling out the id from the nested hash
    current_user.follow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
    # used to incorporate AJAX
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end