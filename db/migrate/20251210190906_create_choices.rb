class CreateChoices < ActiveRecord::Migration[8.1]
  def change
    create_table :choices do |t|
      t.string :text
      t.references :story_node, null: false, foreign_key: true
      t.integer :next_story_node_id

      t.timestamps
    end
  end
end
