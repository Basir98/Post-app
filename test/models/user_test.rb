require "test_helper"

class UserTest < ActiveSupport::TestCase

  
  def setup
    @user = User.new(name: "Example User", email: "user@gmail.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name must be present" do
    @user.name = ""
    assert !@user.valid?
  end

  test "email should be present" do
    @user.email = "    "
    assert !@user.valid?
  end


  test "name should not be too long" do
    @user.name = "a" * 52
    assert !@user.valid?
  end

  test "email should not be too long" do
    @user.email = "t@t.com" * 233
    assert !@user.valid?
  end

  test "name should not be too short" do
    @user.name = "a" * 2
    assert !@user.valid?
  end

  test "email validation should reject invalid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert !duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do 
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password has to be present, this test should fail for the test to pass" do
    @user.password = @user.password_confirmation = " "*6 
    assert !@user.valid?
  end

  test "password should have a minimal length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert !@user.valid?
  end

  test "Confirm that a user with valid name and email but a too-short password isn’t valid" do
    @user.password = @user.password_confirmation = "asd"
    assert !@user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert !@user.authenticated?(:remember, '')
  end
    

  test "associated posts should be destroyed" do
    @user.save 
    @user.posts.create!(content: "Lorem ipsum")
    assert_difference 'Post.count', -1 do
        @user.destroy
    end
  end

  test "should follow and unfollow a user" do 
    test = users(:test)
    archer = users(:archer)
    assert !test.following?(archer)
    test.follow(archer)
    assert test.following?(archer)
    assert archer.followers.include?(test)
    test.unfollow(archer)
    assert !test.following?(archer)
  end

  test "feed should have the right posts" do 
    test = users(:test)
    archer = users(:archer)
    lana = users(:lana)
    # posts from followed user
    lana.posts.each do |post_following|
      assert test.feed.include?(post_following)
      #assert michael.feed.include?(post_following)
    end
    # Post from self
    test.posts.each do |post_self|
      assert test.feed.include?(post_self)
    end
    # Post from unfollwed user
    archer.posts.each do |post_unfollowed|
      assert !test.feed.include?(post_unfollowed)
    end
  end
end
