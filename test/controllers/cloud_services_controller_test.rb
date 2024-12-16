require "test_helper"

class CloudServicesControllerTest < ActionDispatch::IntegrationTest
  test "should get custom_requirements" do
    get cloud_services_custom_requirements_url
    assert_response :success
  end

  test "should get compare" do
    get cloud_services_compare_url
    assert_response :success
  end
end
