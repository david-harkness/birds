require "test_helper"

class NodeTest < ActiveSupport::TestCase
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
  end


  test 'children of root have root as lca and root' do
    n = Node.format_answer(@n1.id,@n2.id)
    assert_equal @n1.id, n[:root_id]
    assert_equal @n1.id, n[:lowest_common_ancestor]
    assert_equal 1, n[:depth]
  end

  test 'child of two has two as lca and one as root' do
    n = Node.format_answer(@n2.id,@n4.id)
    assert_equal @n1.id, n[:root_id]
    assert_equal @n2.id, n[:lowest_common_ancestor]
    assert_equal 2, n[:depth]
  end

  test 'grand child of two has two as lca and one as root' do
    n = Node.format_answer(@n2.id,@n6.id)
    assert_equal @n1.id, n[:root_id]
    assert_equal @n2.id, n[:lowest_common_ancestor]
    assert_equal 2, n[:depth]
  end

  test 'sibling children of two have two as lca and 1 as root' do
    n = Node.format_answer(@n4.id,@n5.id)
    assert_equal @n1.id, n[:root_id]
    assert_equal @n2.id, n[:lowest_common_ancestor]
    assert_equal 2, n[:depth]
  end

  test 'child and nephew two have two as lca and 1 as root' do
    n = Node.format_answer(@n6.id,@n5.id)
    assert_equal @n1.id, n[:root_id]
    assert_equal @n2.id, n[:lowest_common_ancestor]
    assert_equal 2, n[:depth]
  end

  test 'distant cousins have one as root and lca' do
    n = Node.format_answer(@n6.id,@n8.id)
    assert_equal @n1.id, n[:root_id]
    assert_equal @n1.id, n[:lowest_common_ancestor]
    assert_equal 1, n[:depth]
  end

  test 'myself if myself with root' do
    n = Node.format_answer(@n6.id,@n6.id)
    assert_equal @n1.id, n[:root_id]
    assert_equal @n6.id, n[:lowest_common_ancestor]
    assert_equal 4, n[:depth]
  end

  test 'Nothing in common is nil' do
    n = Node.format_answer(@n6.id,@alone)
    assert_nil n[:root_id]
    assert_nil n[:lowest_common_ancestor]
    assert_nil n[:depth]
  end

  test 'missing node is nil' do
    n = Node.format_answer(@n6.id,-1)
    assert_nil n[:root_id]
    assert_nil n[:lowest_common_ancestor]
    assert_nil n[:depth]
  end

  test 'loop is not infinite' do
    n = Node.format_answer(@lp,@lc)
    assert_nil n[:root_id]
    assert_nil n[:lowest_common_ancestor]
    assert_nil n[:depth]
  end
end
