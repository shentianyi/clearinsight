require 'test_helper'

class ProjectItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project_item = project_items(:one)
  end

  test "should get index" do
    get project_items_url
    assert_response :success
  end

  test "should get new" do
    get new_project_item_url
    assert_response :success
  end

  test "should create project_item" do
    assert_difference('ProjectItem.count') do
      post project_items_url, params: { project_item: { project_id: @project_item.project_id, rank: @project_item.rank, source_id: @project_item.source_id, status: @project_item.status, tenant_id: @project_item.tenant_id, user_id: @project_item.user_id } }
    end

    assert_redirected_to project_item_url(ProjectItem.last)
  end

  test "should show project_item" do
    get project_item_url(@project_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_project_item_url(@project_item)
    assert_response :success
  end

  test "should update project_item" do
    patch project_item_url(@project_item), params: { project_item: { project_id: @project_item.project_id, rank: @project_item.rank, source_id: @project_item.source_id, status: @project_item.status, tenant_id: @project_item.tenant_id, user_id: @project_item.user_id } }
    assert_redirected_to project_item_url(@project_item)
  end

  test "should destroy project_item" do
    assert_difference('ProjectItem.count', -1) do
      delete project_item_url(@project_item)
    end

    assert_redirected_to project_items_url
  end
end
