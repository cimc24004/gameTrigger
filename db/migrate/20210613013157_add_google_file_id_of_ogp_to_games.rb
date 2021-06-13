class AddGoogleFileIdOfOgpToGames < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :google_file_id_of_ogp, :string
  end
end
