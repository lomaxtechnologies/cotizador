require 'test_helper'

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Controllers::Helpers
  
  test "should redirect unauthenticated" do
    get users_registrations_url
    assert_response :redirect
  end

end
