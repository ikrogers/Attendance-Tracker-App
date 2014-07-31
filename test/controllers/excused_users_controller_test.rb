require 'test_helper'

class ExcusedUsersControllerTest < ActionController::TestCase
  setup do
    @excused_user = excused_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:excused_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create excused_user" do
    assert_difference('ExcusedUser.count') do
      post :create, excused_user: {  }
    end

    assert_redirected_to excused_user_path(assigns(:excused_user))
  end

  test "should show excused_user" do
    get :show, id: @excused_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @excused_user
    assert_response :success
  end

  test "should update excused_user" do
    patch :update, id: @excused_user, excused_user: {  }
    assert_redirected_to excused_user_path(assigns(:excused_user))
  end

  test "should destroy excused_user" do
    assert_difference('ExcusedUser.count', -1) do
      delete :destroy, id: @excused_user
    end

    assert_redirected_to excused_users_path
  end
end
