require 'test_helper'

class PoolsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pool = pools(:one)
  end

  test "should get index" do
    get pools_url
    assert_response :success
  end

  test "should get new" do
    get new_pool_url
    assert_response :success
  end

  test "should create pool" do
    assert_difference('Pool.count') do
      post pools_url, params: { pool: { active: @pool.active, long_name: @pool.long_name, name: @pool.name, sort_order: @pool.sort_order } }
    end

    assert_redirected_to pool_url(Pool.last)
  end

  test "should show pool" do
    get pool_url(@pool)
    assert_response :success
  end

  test "should get edit" do
    get edit_pool_url(@pool)
    assert_response :success
  end

  test "should update pool" do
    patch pool_url(@pool), params: { pool: { active: @pool.active, long_name: @pool.long_name, name: @pool.name, sort_order: @pool.sort_order } }
    assert_redirected_to pool_url(@pool)
  end

  test "should destroy pool" do
    assert_difference('Pool.count', -1) do
      delete pool_url(@pool)
    end

    assert_redirected_to pools_url
  end
end
