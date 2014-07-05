require 'test_helper'

class InGroupsControllerTest < ActionController::TestCase
  setup do
    @in_group = in_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:in_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create in_group" do
    assert_difference('InGroup.count') do
      post :create, in_group: {  }
    end

    assert_redirected_to in_group_path(assigns(:in_group))
  end

  test "should show in_group" do
    get :show, id: @in_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @in_group
    assert_response :success
  end

  test "should update in_group" do
    patch :update, id: @in_group, in_group: {  }
    assert_redirected_to in_group_path(assigns(:in_group))
  end

  test "should destroy in_group" do
    assert_difference('InGroup.count', -1) do
      delete :destroy, id: @in_group
    end

    assert_redirected_to in_groups_path
  end
end
