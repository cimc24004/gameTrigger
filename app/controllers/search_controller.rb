class SearchController < ApplicationController
  before_action :lists_receive
  def index
    event_tags = []
    keywards = params[:keywards]
    tag_game_event_ids = []
    master_game_event_ids = []
    title_name_game_event_ids = []
    @game_id = params[:game_id]
    if @game_id.blank?
      @game_id = cookies[:search_game_id]
      if cookies[:search_game_id].blank?
        @game_id = Game.all.first.id
      end
    end
    cookies[:search_game_id] = @game_id
    @games = Game.all.order(title: :asc)
    @game_search_find = Game.find cookies[:search_game_id].to_i
    @game = Game.find @game_id.to_i
    if keywards.present?
      # 全角スペースは半角スペースに変換して半角スペースで配列を作る
      keywards_sp = keywards.gsub("　", " ").split(" ")

      keywards_sp.each do |keyward|
        tag_game_event_ids += GameEventTag.where('tag_name like ?', "#{keyward}%").pluck(:game_event_id)
        master_game_event_ids += @game.game_events.where("event_master like ?", "%#{keyward}%").pluck(:id)
        title_name_game_event_ids += @game.game_events.where("title like ?", "%#{keywards}%").pluck(:id)
      end
    else
      title_name_game_event_ids = @game.game_events.pluck(:id)
    end

    @game_events = @game.game_events.where(id: title_name_game_event_ids)
                   .or(@game.game_events.where(id: tag_game_event_ids))
                   .or(@game.game_events.where(id: master_game_event_ids))
                   .includes(:game_event_tags).page(params[:page]).per(10).order(created_at: :desc)
    @lists.push("title" => "ゲーム大会の検索", "link" => "")
  end


  private

  def lists_receive
    @lists = []
  end
end
