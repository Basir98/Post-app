require "test_helper"

class LikeTest < ActiveSupport::TestCase

  def setup
    @user = users(:test)
    @post = @user.posts.build(content: "Lorem ipsum")
    @like = Like.new(user: @user, user_id: users(:test).id, post: @post)
  end

  test "should be valid" do
    assert @like.valid?
  end

  test "should require user" do
    @like.user = nil;
    assert !@like.valid?
  end

  test "should require post" do
    @like.post = nil;
    assert !@like.valid?
  end
end
