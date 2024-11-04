require "test_helper"

class NodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @n1 = nodes(:one)
    @n2 = nodes(:two)
    @n3 = nodes(:three)
    @n4 = nodes(:four)
    @n5 = nodes(:five)
    @n6 = nodes(:six)
    @n7 = nodes(:seven)
    @n8 = nodes(:eight)
    @n9 = nodes(:nine)
    @lp = nodes(:loop_parent)
    @lc = nodes(:loop_child)
    @alone = nodes(:alone)
    @bird1 = birds(:one)
    @bird2 = birds(:two)
  end

  test "birds" do
    get birds_nodes_path([ @bird1.id, @bird2.id ])
    assert_response :success
    answer = @response.parsed_body
    assert answer.any? { |x| x[:id] == @bird1.id }
    assert answer.any? { |x| x[:id] == @bird2.id }
    assert answer.any? { |x| x[:node_id] == @n1.id }
    assert answer.any? { |x| x[:node_id] == @n2.id }
    # Could include test to make sure right node is attached to correct bird
  end

  test "top and child have top as lca" do
    get node_common_ancestors_url(node_id: @n1.id, id: @n2.id), as: :json
    assert_response :success
    answer = @response.parsed_body
    assert_equal @n1.id, answer[:root_id]
    assert_equal @n1.id, answer[:lowest_common_ancestor]
    assert_equal 1, answer[:depth]
  end

  test "deep siblings have parent as lca " do
    get node_common_ancestors_url(node_id: @n8.id, id: @n9.id), as: :json
    assert_response :success
    answer = @response.parsed_body
    assert_equal @n1.id, answer[:root_id]
    assert_equal @n7.id, answer[:lowest_common_ancestor]
    assert_equal 3, answer[:depth]
  end

  test "Missing gives null results" do
    get node_common_ancestors_url(node_id: -1, id: @n9.id), as: :json
    assert_response :success
    answer = @response.parsed_body
    assert_nil answer[:root_id]
    assert_nil answer[:lowest_common_ancestor]
    assert_nil answer[:depth]
  end
end
