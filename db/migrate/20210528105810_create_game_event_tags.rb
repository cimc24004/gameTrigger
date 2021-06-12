class CreateGameEventTags < ActiveRecord::Migration[6.1]
  def change
    create_table :game_event_tags do |t|
      t.string :tag_name
      t.references :game_event, null: false, foreign_key: true
      t.index :tag_name
      t.timestamps
    end
  end
end
