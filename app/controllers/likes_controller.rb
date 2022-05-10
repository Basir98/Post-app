class LikesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @like = current_user.likes.new(like_params)
    if !@like.save
      flash[:warning] = "Error: was not able to like this comment" 
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  def destroy
    @like = current_user.likes.find(params[:id])
    post = @like.post
    @like.destroy
    redirect_to root_path
  end

  private 

  def like_params
    params.require(:like).permit(:post_id)
  end
end