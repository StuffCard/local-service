require 'test_helper'

class CheckinsControllerTest < ActionController::TestCase
  test "should create checkin" do
    assert_difference('Checkin.count') do
      post :create, checkin: {smartcard_id: "123", reader_id: "1", location_key: "abc"}
    end
    assert_response :success
  end
end
