require 'test_helper'

class PdcaItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pdca_item = pdca_items(:one)
  end

  test "should get index" do
    get pdca_items_url
    assert_response :success
  end

  test "should get new" do
    get new_pdca_item_url
    assert_response :success
  end

  test "should create pdca_item" do
    assert_difference('PdcaItem.count') do
      post pdca_items_url, params: { pdca_item: { due_time: @pdca_item.due_time, end_time: @pdca_item.end_time, improvement_point: @pdca_item.improvement_point, item: @pdca_item.item, remark: @pdca_item.remark, saving: @pdca_item.saving, start_time: @pdca_item.start_time, status: @pdca_item.status, taskable_id: @pdca_item.taskable_id, taskable_type: @pdca_item.taskable_type, type: @pdca_item.type, user_id: @pdca_item.user_id } }
    end

    assert_redirected_to pdca_item_url(PdcaItem.last)
  end

  test "should show pdca_item" do
    get pdca_item_url(@pdca_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_pdca_item_url(@pdca_item)
    assert_response :success
  end

  test "should update pdca_item" do
    patch pdca_item_url(@pdca_item), params: { pdca_item: { due_time: @pdca_item.due_time, end_time: @pdca_item.end_time, improvement_point: @pdca_item.improvement_point, item: @pdca_item.item, remark: @pdca_item.remark, saving: @pdca_item.saving, start_time: @pdca_item.start_time, status: @pdca_item.status, taskable_id: @pdca_item.taskable_id, taskable_type: @pdca_item.taskable_type, type: @pdca_item.type, user_id: @pdca_item.user_id } }
    assert_redirected_to pdca_item_url(@pdca_item)
  end

  test "should destroy pdca_item" do
    assert_difference('PdcaItem.count', -1) do
      delete pdca_item_url(@pdca_item)
    end

    assert_redirected_to pdca_items_url
  end
end
