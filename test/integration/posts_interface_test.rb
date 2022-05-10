require "test_helper"

class PostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:test)
  end

  test "post interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
        
    # Invalid submission
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: "" } } 
    end
    assert_select 'div#error_explanation'

    # Valid submission
    content = "This post really ties the room together" 
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post: { content: content } } 
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body

    # Like post
    assert_difference 'Like.count', 0 do
      post likes_path, params: { like: { user: @user, user_id: users(:test).id, post: @post } } 
    end
    assert_redirected_to root_path

    # Delete post
    first_post = @user.posts.paginate(page: 1).first 
    assert_difference 'Post.count', -1 do
      delete post_path(first_post)
    end

    # Visit different user (no delete links)
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end

end
