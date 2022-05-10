require "test_helper"

class DislikeTest < ActiveSupport::TestCase

  def setup
    @user = users(:test)
    @post = @user.posts.build(content: "Lorem ipsum")
    @dislike = Dislike.new(user: @user, user_id: users(:test).id, post: @post)
  end

  test "should be valid" do
    assert @dislike.valid?
  end

  test "should require user" do
    @dislike.user = nil;
    assert !@dislike.valid?
  end

  test "should require post" do
    @dislike.post = nil;
    assert !@dislike.valid?
  end
end
