class SearchController < ApplicationController
  def index
    event_tags = []
    keywards = params[:keywards]
    tag_ids = []
    game_id = params[:game_id]
    if game_id.blank?
      game_id = 1
    end
    cookies[:search_game_id] = game_id
    @games = Game.all.order(id: :desc)
    @game_search_find = Game.find cookies[:search_game_id].to_i
    if keywards.present?
      # 全角スペースは半角スペースに変換して半角スペースで配列を作る
      tag_sp = keywards.gsub("　", " ").split(" ")
      # tag_sp.each do |tag|
      #   # @game_events = GameEvent.where("title like ?", "%#{title}%").joins(:game_event_tags).or(GameEvent.joins(:game_event_tags).where(game_event_tags: {tag_name: tag_name}))
      #   event_tags.push(GameEventTag.where(tag_name: tag).pluck(:game_event_id))
      # end
      tag_ids = GameEventTag.where(tag_name: tag_sp).pluck(:game_event_id)
    end

    @game = Game.find game_id.to_i
    @game_events = @game.game_events.where("title like ?", "%#{keywards}%")
                   .or(@game.game_events.where(id: tag_ids)).includes(:game_event_tags).page(params[:page]).per(10).order(created_at: :desc)
    
  end

end
