class NodesController < ApplicationController
  def common_ancestors
    render json: Node.format_answer(params[:node_id], params[:id])
  end

  # Credit to https://codepen.io/augbog/pen/LEXZKK
  def demo
    @whole_tree = Node.whole_tree
  end
end
