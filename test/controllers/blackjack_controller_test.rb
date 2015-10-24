require 'test_helper'

class BlackjackControllerTest < ActionController::TestCase
  test "should get join" do
    get :join
    assert_response :success
  end

  test "should get hit" do
    get :hit
    assert_response :success
  end

  test "should get stay" do
    get :stay
    assert_response :success
  end

  test "should get split" do
    get :split
    assert_response :success
  end

end
