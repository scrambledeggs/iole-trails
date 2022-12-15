require "test_helper"

class PracticesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get practices_create_url
    assert_response :success
  end
end
