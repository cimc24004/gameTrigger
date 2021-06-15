class AddEventMasterIndexToGameEvents < ActiveRecord::Migration[6.1]
  def change
    add_index :game_events, :event_master
  end
end
