# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Clear old data if reseeding
Choice.delete_all
StoryNode.delete_all

# Create nodes
start = StoryNode.create!(
  title: "At the Crossroads",
  body:  "{{name}}, stand at a lonely crossroads at dusk. The forest looms to the north and a small village lies to the east."
)

forest = StoryNode.create!(
  title: "Dark Forest",
  body:  "The trees close in around you. You hear distant howls. A narrow path leads deeper, and another back to the road."
)

village = StoryNode.create!(
  title: "Quiet Village",
  body:  "The village is eerily quiet. A tavern sign creaks in the wind. Lanterns flicker in a few windows."
)

ending_good = StoryNode.create!(
  title: "Warm Hearth Ending",
  body:  "You find shelter and safety in the village tavern. For tonight, at least, you are safe."
)

ending_bad = StoryNode.create!(
  title: "Lost in the Dark",
  body:  "The forest swallows you whole. No one hears your final cry."
)

# Create choices
Choice.create!(
  text: "Go north into the forest",
  story_node: start,
  next_story_node: forest
)

Choice.create!(
  text: "Head east toward the village",
  story_node: start,
  next_story_node: village
)

Choice.create!(
  text: "Go deeper into the forest",
  story_node: forest,
  next_story_node: ending_bad
)

Choice.create!(
  text: "Retreat back to the crossroads",
  story_node: forest,
  next_story_node: start
)

Choice.create!(
  text: "Enter the tavern",
  story_node: village,
  next_story_node: ending_good
)

Choice.create!(
  text: "Leave the village and return to the crossroads",
  story_node: village,
  next_story_node: start
)
