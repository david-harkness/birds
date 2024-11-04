class NodesController < ApplicationController
  def common_ancestors
    render json: Node.format_answer(node_params[:node_id], node_params[:id])
  end

  # Credit to https://codepen.io/augbog/pen/LEXZKK
  def demo
    @whole_tree = Node.whole_tree
  end

  # http://localhost:3000/nodes/birds/2100480
  def birds
    nodes = bird_params.split("/")
    render json: Bird.all_child_birds(nodes)
  end

  private

  def node_params
    params.permit(:id, :node_id)
  end

  def bird_params
    params.require(:ids)
  end
end
