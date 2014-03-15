require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  setup do
    @task = tasks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tasks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create task" do
    assert_difference('Task.count') do
      post :create, task: { comments_count: @task.comments_count, description: @task.description, end_date: @task.end_date, name: @task.name, project_id: @task.project_id, start_date: @task.start_date, team_id: @task.team_id, tracker_id: @task.tracker_id, user_id: @task.user_id }
    end

    assert_redirected_to task_path(assigns(:task))
  end

  test "should show task" do
    get :show, id: @task
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @task
    assert_response :success
  end

  test "should update task" do
    patch :update, id: @task, task: { comments_count: @task.comments_count, description: @task.description, end_date: @task.end_date, name: @task.name, project_id: @task.project_id, start_date: @task.start_date, team_id: @task.team_id, tracker_id: @task.tracker_id, user_id: @task.user_id }
    assert_redirected_to task_path(assigns(:task))
  end

  test "should destroy task" do
    assert_difference('Task.count', -1) do
      delete :destroy, id: @task
    end

    assert_redirected_to tasks_path
  end
end
