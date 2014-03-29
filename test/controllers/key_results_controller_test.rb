require 'test_helper'

class KeyResultsControllerTest < ActionController::TestCase
  setup do
    @key_result = key_results(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:key_results)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create key_result" do
    assert_difference('KeyResult.count') do
      post :create, key_result: { author_id: @key_result.author_id, end_date: @key_result.end_date, name: @key_result.name, objective_id: @key_result.objective_id, start_date: @key_result.start_date, user_id: @key_result.user_id }
    end

    assert_redirected_to key_result_path(assigns(:key_result))
  end

  test "should show key_result" do
    get :show, id: @key_result
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @key_result
    assert_response :success
  end

  test "should update key_result" do
    patch :update, id: @key_result, key_result: { author_id: @key_result.author_id, end_date: @key_result.end_date, name: @key_result.name, objective_id: @key_result.objective_id, start_date: @key_result.start_date, user_id: @key_result.user_id }
    assert_redirected_to key_result_path(assigns(:key_result))
  end

  test "should destroy key_result" do
    assert_difference('KeyResult.count', -1) do
      delete :destroy, id: @key_result
    end

    assert_redirected_to key_results_path
  end
end
