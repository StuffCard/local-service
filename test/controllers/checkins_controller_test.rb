require 'test_helper'

class CheckinsControllerTest < ActionController::TestCase
  test "should create checkin" do
    assert_difference('Checkin.count') do
      post :create, checkin: {smartcard_id: "123", reader_id: "1", location_key: "lo4KN3mn8y0wMaDDEAroKnLUzVZbSfgc8l2d6FKw"}
    end
    assert_response :success
  end

  test "should fail to create checkin with invalid data" do
    post :create, checkin: {smartcard_id: "123", reader_id: "1", location_key: "xxx"}
    assert_response :bad_request
  end
end
