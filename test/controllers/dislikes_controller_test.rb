require "test_helper"

class DislikesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test)
    @post = @user.posts.build(content: "Lorem ipsum")
    @dislike = dislikes(:three)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Dislike.count' do
        post dislikes_path, params: { dislike: { user: @user, user_id: users(:test).id, post: @post } } 
    end
    assert_redirected_to login_url 
  end

  test "valid dislike with user logged in" do
    log_in_as(@user)
    assert_no_difference 'Dislike.count' do
        post dislikes_path, params: { dislike: { user: @user, user_id: users(:test).id, post: @post } } 
    end
    assert_redirected_to root_path
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Dislike.count' do
      delete dislike_path(@dislike)
    end
    assert_redirected_to login_url
  end 
end