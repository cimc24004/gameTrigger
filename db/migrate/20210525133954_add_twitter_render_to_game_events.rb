class AddTwitterRenderToGameEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :game_events, :twitter_render, :text
  end
end
