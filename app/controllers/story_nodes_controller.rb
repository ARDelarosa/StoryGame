class StoryNodesController < ApplicationController
  def start
    if StoryNode.none?
      render plain: "No story nodes yet. Run `bin/rails db:seed` to create the initial story.", status: :not_found
      return
    end

    @start_node = StoryNode.order(:id).first
  end

  def show
    if StoryNode.none?
      render plain: "No story nodes yet. Run `bin/rails db:seed` to create the initial story.", status: :not_found
      return
    end

    if params[:id].present?
      @node = StoryNode.find_by(id: params[:id])
    end

    @node ||= StoryNode.order(:id).first
  end
end
