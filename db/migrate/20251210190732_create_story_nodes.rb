class CreateStoryNodes < ActiveRecord::Migration[8.1]
  def change
    create_table :story_nodes do |t|
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
