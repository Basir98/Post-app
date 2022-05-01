require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest


  def setup
    @user = users(:test)
  end

  test "Login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: {session: {email: "", password: ""}}
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end


  test "Login with valid information" do
    get login_path
    post login_path, params: {session: {email: @user.email, password: "password"}}
    assert_redirected_to root_path    # check the right redirect
    follow_redirect!      # visit the target page 
    assert_template 'static_pages/home'   
    assert_select "a[href=?]", login_path, count: 0  # verifies that the login link disappears by verifying that there are zero login path links
    # with count: 0 we expect there to be zero links matching the given pattern
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end


  test "Login with valid information followed by logout" do
    get login_path
    post login_path, params: {session: {email: @user.email, password: "password"}}

    assert is_logged_in?
    assert_redirected_to root_path    # check the right redirect
    follow_redirect!      # visit the target page 
    assert_template 'static_pages/home'   
    assert_select "a[href=?]", login_path, count: 0  # verifies that the login link disappears by verifying that there are zero login path links
    # with count: 0 we expect there to be zero links matching the given pattern
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

    delete logout_path        #issue a delete request to the logout path
    assert_not is_logged_in?    # verify that ther user is logged out
    assert_redirected_to root_url   # redirect to the root URL 

    delete logout_path   # simulate a user clicking logout in a second window
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count:0
    assert_select "a[href=?]", user_path(@user), count: 0
  end


  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies[:remember_token]
  end

  test "Login without remembering" do 
    # log in to set the cookie
    log_in_as(@user, remember_me: '1')
    # log in again and verify that the cookie is deleted
    log_in_as(@user, remember_me: '0')
    assert_empty cookies[:remember_token]
  end

end
