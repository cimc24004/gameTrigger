class GameEventTag < ApplicationRecord
  belongs_to :game_event
  validates :tag_name, presence: true
end
