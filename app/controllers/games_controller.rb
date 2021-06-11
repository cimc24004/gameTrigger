class GamesController < ApplicationController
    before_action :authenticate_user!, only: [:create, :edit, :update, :new, :destroy]
    before_action :game_find, only: [:edit, :update, :show, :destroy]
    before_action :admin_check, only: [:edit,:update, :create, :destroy, :new]
    # before_action :user_auth_check, only: [:edit, :update, :destroy]
    def index
        @games = Game.all.includes(:game_events).order(id: :desc)
        @game_events = GameEvent.all.includes(:game_event_tags).order(created_at: :desc).limit(5)
    end
    def new
        @game = Game.new
    end

    def create
        @game = Game.new(game_params)
        @game.user_id = current_user.id
        @game.save!
        redirect_to root_path
    end

    def update
        @game.update!(game_params)
        redirect_to @game
    end

    def edit

    end

    def show
        event_tags = []
        keywards = params[:keywards]
        tag_ids = []
        if keywards.present?
          # 全角スペースは半角スペースに変換して半角スペースで配列を作る
          tag_sp = keywards.gsub("　", " ").split(" ")
          # tag_sp.each do |tag|
          #   # @game_events = GameEvent.where("title like ?", "%#{title}%").joins(:game_event_tags).or(GameEvent.joins(:game_event_tags).where(game_event_tags: {tag_name: tag_name}))
          #   event_tags.push(GameEventTag.where(tag_name: tag).pluck(:game_event_id))
          # end
          tag_ids = GameEventTag.where(tag_name: tag_sp).pluck(:game_event_id)
        end
        @game_events = @game.game_events.where("title like ?", "%#{keywards}%")
                       .or(@game.game_events.where(id: tag_ids)).includes(:game_event_tags, :game, :user)
                       .page(params[:page]).per(10).order(created_at: :desc)
        

    end

    def destroy
        @game.destroy
        redirect_to root_path
    end

    private

    def game_params
        params.require(:game).permit(:title, :image)
    end
    
    def game_find
        @game = Game.find params[:id]
    end

    def user_auth_check
        if current_user.id != @game.user_id
            redirect_to root_path and return
        end
    end

    def admin_check
        unless current_user.admin
            redirect_to root_path and return
        end
    end
end
