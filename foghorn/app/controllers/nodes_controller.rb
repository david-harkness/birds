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
    nodes = params[:ids].split('/')
    birds = Bird.all_child_birds(nodes)
    render json: birds

  end
end
