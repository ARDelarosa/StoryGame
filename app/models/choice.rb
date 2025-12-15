class Choice < ApplicationRecord
  belongs_to :story_node
  belongs_to :next_story_node, class_name: "StoryNode", optional: true
end
