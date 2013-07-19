require 'test_helper'

class CheckinsControllerTest < ActionController::TestCase
  test "should create checkin" do
    assert_difference('Checkin.count') do
      post :create, checkin: {smartcard_id: "123", reader_id: "1"}
    end
    assert_response :success
    assert_equal Rails.application.config.service.location.key, Checkin.last.location_key
  end

  test "should fail to create checkin with invalid data" do
    post :create, checkin: {smartcard_id: "123"}
    assert_response :bad_request
  end
end
