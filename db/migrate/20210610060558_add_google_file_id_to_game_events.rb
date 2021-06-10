class AddGoogleFileIdToGameEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :game_events, :google_file_id, :string
  end
end
