require "test_helper"

class LikesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:test)
    @post = @user.posts.build(content: "Lorem ipsum")
    @like = likes(:one)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Like.count' do
      post likes_path, params: { like: { user: @user, user_id: users(:test).id, post: @post } } 
    end
    assert_redirected_to login_url 
  end

  test "valid like whith user logged in" do
    log_in_as(@user)
    assert_difference 'Like.count', 0 do
        post likes_path, params: { like: { user: @user, user_id: users(:test).id, post: @post } } 
    end
    assert_redirected_to root_path
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Like.count' do
      delete like_path(@like)
    end
    assert_redirected_to login_url
  end 
end