class StoryNode < ApplicationRecord
  has_many :choices, dependent: :destroy
end
