class NodesController < ApplicationController
  def common_ancestors
    render json: Node.format_answer(params[:node_id], params[:id])
  end

  # Credit to https://codepen.io/augbog/pen/LEXZKK
  def demo
    @whole_tree = Node.whole_tree
  end

  def birds
    # TODO: Hacky. Short on time
    nodes = Node.find(params[:ids].split('/'))
    birds = nodes.map{|n| n.all_child_birds}.flatten.uniq # TODO: N + 1
    # TODO: Need to create a map a unique map of node ids, join to birds table.
    render json: birds

  end
end
