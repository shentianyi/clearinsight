require 'test_helper'

class NodeSetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @node_set = node_sets(:one)
  end

  test "should get index" do
    get node_sets_url
    assert_response :success
  end

  test "should get new" do
    get new_node_set_url
    assert_response :success
  end

  test "should create node_set" do
    assert_difference('NodeSet.count') do
      post node_sets_url, params: { node_set: { diagram_id: @node_set.diagram_id } }
    end

    assert_redirected_to node_set_url(NodeSet.last)
  end

  test "should show node_set" do
    get node_set_url(@node_set)
    assert_response :success
  end

  test "should get edit" do
    get edit_node_set_url(@node_set)
    assert_response :success
  end

  test "should update node_set" do
    patch node_set_url(@node_set), params: { node_set: { diagram_id: @node_set.diagram_id } }
    assert_redirected_to node_set_url(@node_set)
  end

  test "should destroy node_set" do
    assert_difference('NodeSet.count', -1) do
      delete node_set_url(@node_set)
    end

    assert_redirected_to node_sets_url
  end
end
