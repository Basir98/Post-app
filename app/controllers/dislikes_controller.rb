class DislikesController < ApplicationController
  def create
    @dislike = current_user.dislikes.new(dislike_params)
    if !@dislike.save
      flash[:warning] = "Error: was not able to dislike this comment" 
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  def destroy
    @dislike = current_user.dislikes.find(params[:id])
    post = @dislike.post
    @dislike.destroy
    redirect_to root_path
  end

  private 

  def dislike_params
    params.require(:dislike).permit(:post_id)
  end
end