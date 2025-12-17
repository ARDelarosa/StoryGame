class StoryNodesController < ApplicationController
  before_action :ensure_story_exists, only: [:start, :start_game, :show]

  def start
    @start_node = StoryNode.order(:id).first
    @player_name = session[:player_name]
    @can_continue = session[:current_node_id].present?
  end

  def start_game
    # Starting a NEW game
    session[:player_name] = params[:player_name].presence || "Traveler"

    # Reset game state
    session[:current_node_id] = StoryNode.order(:id).first.id
    session[:inventory] = []
    session[:stats] = { "health" => 10, "gold" => 0 }

    redirect_to story_node_path(session[:current_node_id])
  end

  def show
    # If no id given but we have a saved game, go to saved node
    if params[:id].present?
      @node = StoryNode.find_by(id: params[:id])
    elsif session[:current_node_id].present?
      @node = StoryNode.find_by(id: session[:current_node_id])
    end

    @node ||= StoryNode.order(:id).first

    # Save progress
    session[:current_node_id] = @node.id

    # Initialize inventory and stats if missing
    session[:inventory] ||= []
    session[:stats] ||= { "health" => 10, "gold" => 0 }

    @player_name = session[:player_name]
    @inventory   = session[:inventory]
    @stats       = session[:stats]

    # Example: simple flags / effects based on node
    apply_node_effects

    # Replace {{name}} in the body if present
    @rendered_body = personalize_body(@node.body, @player_name)
  end

  private

  def ensure_story_exists
    if StoryNode.none?
      render plain: "No story nodes yet. Run `bin/rails db:seed` to create the initial story.", status: :not_found
    end
  end

  def personalize_body(body, name)
    return body if body.blank?
    name ||= "Traveler"
    body.gsub("{{name}}", name)
  end

  # Basic example of inventory/stats logic
  def apply_node_effects
    # Make sure we’re working with mutable structures
    inv   = session[:inventory] || []
    stats = session[:stats]     || { "health" => 10, "gold" => 0 }

    # Example rules: tweak however you want
    case @node.title
    when "Dark Forest"
      # First time here, you find a Lantern and lose 1 health
      unless inv.include?("Lantern")
        inv << "Lantern"
        stats["health"] = stats.fetch("health", 10) - 1
      end
    when "Quiet Village"
      # Rest and heal a bit
      stats["health"] = [stats.fetch("health", 10) + 2, 10].min
    when "Warm Hearth Ending"
      # Reward gold at this ending
      stats["gold"] = stats.fetch("gold", 0) + 5
    end

    # Save back
    session[:inventory] = inv
    session[:stats]     = stats

    @inventory = inv
    @stats     = stats
  end
end
