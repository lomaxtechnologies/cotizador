require "test_helper"

class UserTest < ActiveSupport::TestCase
  
  test "should not save empty role" do
    role = Role.new
    assert_not role.save
  end

  test "Should save a complete role" do
    role = Role.new(name: "TestRole")
    assert role.save
  end

  test "should not save user without a password" do
    role = Role.first
    user = User.new(email: "test@test.test", role: role)
    assert_not user.save
  end

  test "should not save user without a role" do
    user = User.new(email: "test@test.test",  password: "123456789", password_confirmation: "123456789")
    assert_not user.save
  end

  test "should save user with a role and password" do
    role = Role.first
    user = User.new(email: "test@test.test", role: role, password: "123456789", password_confirmation: "123456789")
    assert user.save
  end

  test "should not save used detail without a user" do
    user_detail = UserDetail.new(name: "Test Testing",last_name: "Tested Tester",phone: "(502) 0099-9900")
    assert_not user_detail.save
  end

  test "should CUD an user" do
    role = Role.first
    user = User.new(email: "test@test.test", role: role, password: "123456789", password_confirmation: "123456789")
    user_detail = UserDetail.new(name:"Test Testing", last_name: "Tested Tester", phone: "(502) 1234 - 5678")
    assert user.create_user(user_detail)
    role = Role.last
    user_params = {role_id: role.id}
    user_detail_params = {phone: "(+502) 1234-5678"}
    assert user.update_user(user_params,user_detail_params)
    assert user.destroy_user
  end

  test "should rollback if update fails" do
    phone = "(502) 1234 - 5678"
    invalid_user_id = 999999
    role = Role.first
    user = User.new(email: "test@test.test", role: role, password: "123456789", password_confirmation: "123456789")
    user_detail = UserDetail.new(name:"Test Testing", last_name: "Tested Tester", phone: phone)
    assert user.create_user(user_detail)
    role = Role.last
    user_params = {role_id: role.id}
    user_detail_params = {phone: "(+502) 1234-5678", user_id: invalid_user_id}
    assert_not user.update_user(user_params,user_detail_params)
    stored_user_detail = UserDetail.last
    assert stored_user_detail.phone == phone
  end

end
