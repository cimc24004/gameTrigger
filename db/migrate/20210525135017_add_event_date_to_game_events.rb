class AddEventDateToGameEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :game_events, :event_date, :date
  end
end
