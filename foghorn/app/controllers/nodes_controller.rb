class NodesController < ApplicationController
  before_action :set_node, only: %i[ show update destroy ]

  # GET /nodes
  # GET /nodes.json
  def index
    @nodes = Node.all
  end

  # GET /nodes/1
  # GET /nodes/1.json
  def show
  end

  # POST /nodes
  # POST /nodes.json
  def create
    @node = Node.new(node_params)

    if @node.save
      render :show, status: :created, location: @node
    else
      render json: @node.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /nodes/1
  # PATCH/PUT /nodes/1.json
  def update
    if @node.update(node_params)
      render :show, status: :ok, location: @node
    else
      render json: @node.errors, status: :unprocessable_entity
    end
  end

  # DELETE /nodes/1
  # DELETE /nodes/1.json
  def destroy
    @node.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_node
      @node = Node.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def node_params
      params.expect(node: [ :node_id ])
    end
end
