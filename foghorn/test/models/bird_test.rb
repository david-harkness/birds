require "test_helper"

class BirdTest < ActiveSupport::TestCase
  setup do
    @node = nodes(:one)
    @nine = nodes(:nine)
  end
  test "Can add bird to root node" do
    bird = @node.birds.new(name: "Roc")
    bird.save
    assert_equal @node.reload.birds.where(name: 'Roc').first.name, bird.name
  end
end
