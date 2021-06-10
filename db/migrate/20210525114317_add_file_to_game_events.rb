class AddFileToGameEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :game_events, :file, :string
  end
end
