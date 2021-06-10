class CreateGameEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :game_events do |t|
      t.references :user
      t.references :game
      t.string :title
      t.text :body
      t.timestamps
    end
  end
end
