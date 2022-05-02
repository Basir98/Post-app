require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
 
  def setup
    @admin = users(:test) 
    @non_admin = users(:archer)
  end
    
  test "index as admin including pagination and delete links" do 
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination' 
    first_page_of_users = User.first   
    assert_select 'a[href=?]', user_path(first_page_of_users), text: first_page_of_users.name 
    unless first_page_of_users == @admin
      assert_select 'a[href=?]', user_path(first_page_of_users), text: 'delete' 
    end  
  end
    
  test "index as non-admin" do 
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0  
  end

end
