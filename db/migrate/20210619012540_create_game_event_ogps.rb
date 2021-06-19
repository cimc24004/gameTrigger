class CreateGameEventOgps < ActiveRecord::Migration[6.1]
  def change
    create_table :game_event_ogps do |t|
      t.string :ogp_url
      t.string :ogp_google_file_id
      t.string :ogp_title
      t.text :ogp_body
      t.references :game_event
      t.timestamps
    end
  end
end
