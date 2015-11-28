require 'test_helper'

class CartControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get payu_callback" do
    get :payu_callback
    assert_response :success
  end

end
