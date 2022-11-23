require "test_helper"

class RaceControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get race_index_url
    assert_response :success
  end

  test "should get show" do
    get race_show_url
    assert_response :success
  end

  test "should get new" do
    get race_new_url
    assert_response :success
  end

  test "should get create" do
    get race_create_url
    assert_response :success
  end

  test "should get edit" do
    get race_edit_url
    assert_response :success
  end

  test "should get update" do
    get race_update_url
    assert_response :success
  end

  test "should get destroy" do
    get race_destroy_url
    assert_response :success
  end
end
