class AddGoogleFileToGames < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :google_file_id, :string
    add_column :games, :google_file_url, :string
  end
end
