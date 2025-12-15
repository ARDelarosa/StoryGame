require "test_helper"

class StoryNodesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get story_nodes_show_url
    assert_response :success
  end
end
