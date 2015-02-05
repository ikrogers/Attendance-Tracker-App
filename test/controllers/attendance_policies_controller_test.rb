require 'test_helper'

class AttendancePoliciesControllerTest < ActionController::TestCase
  setup do
    @attendance_policy = attendance_policies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:attendance_policies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create attendance_policy" do
    assert_difference('AttendancePolicy.count') do
      post :create, attendance_policy: {  }
    end

    assert_redirected_to attendance_policy_path(assigns(:attendance_policy))
  end

  test "should show attendance_policy" do
    get :show, id: @attendance_policy
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @attendance_policy
    assert_response :success
  end

  test "should update attendance_policy" do
    patch :update, id: @attendance_policy, attendance_policy: {  }
    assert_redirected_to attendance_policy_path(assigns(:attendance_policy))
  end

  test "should destroy attendance_policy" do
    assert_difference('AttendancePolicy.count', -1) do
      delete :destroy, id: @attendance_policy
    end

    assert_redirected_to attendance_policies_path
  end
end
