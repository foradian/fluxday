require 'test_helper'

class OauthApplicationsControllerTest < ActionController::TestCase
  setup do
    @oauth_application = oauth_applications(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:oauth_applications)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create oauth_application" do
    assert_difference('OauthApplication.count') do
      post :create, oauth_application: { name: @oauth_application.name, redirect_uri: @oauth_application.redirect_uri }
    end

    assert_redirected_to oauth_application_path(assigns(:oauth_application))
  end

  test "should show oauth_application" do
    get :show, id: @oauth_application
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @oauth_application
    assert_response :success
  end

  test "should update oauth_application" do
    patch :update, id: @oauth_application, oauth_application: { name: @oauth_application.name, redirect_uri: @oauth_application.redirect_uri }
    assert_redirected_to oauth_application_path(assigns(:oauth_application))
  end

  test "should destroy oauth_application" do
    assert_difference('OauthApplication.count', -1) do
      delete :destroy, id: @oauth_application
    end

    assert_redirected_to oauth_applications_path
  end
end
