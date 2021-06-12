class AddOgpGoogleFileIdToGameEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :game_events, :google_file_id_of_ogp, :string
  end
end
