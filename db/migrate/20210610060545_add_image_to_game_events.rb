class AddImageToGameEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :game_events, :image, :string
  end
end
