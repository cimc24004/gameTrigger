class GameEventsController < ApplicationController
    
    before_action :authenticate_user!, only: [:create, :destroy, :update, :new, :edit, :game_events_new]
    before_action :parent_game_find, only: [:create, :new, :show, :update, :destroy, :edit]
    before_action :game_event_find, only: [:show, :update, :destroy, :edit]
    before_action :user_auth_check, only: [:destroy, :update, :edit]
    def index
        # event_tags = []
        # keywards = params[:keywards]
        # tag_ids = []
        # if keywards.present?
        #   # 全角スペースは半角スペースに変換して半角スペースで配列を作る
        #   tag_sp = keywards.gsub("　", " ").split(" ")
        #   # tag_sp.each do |tag|
        #   #   # @game_events = GameEvent.where("title like ?", "%#{title}%").joins(:game_event_tags).or(GameEvent.joins(:game_event_tags).where(game_event_tags: {tag_name: tag_name}))
        #   #   event_tags.push(GameEventTag.where(tag_name: tag).pluck(:game_event_id))
        #   # end
        #   tag_ids = G
        # end
        @game_events = GameEvent.all.includes(:game, :game_event_tags)
                       .page(params[:page]).per(10).order(created_at: :desc)
        @games = Game.all.order(id: :desc)
        
    end

    def new
        @game_event = @game.game_events.build
    end

    def game_events_new
        @game_event = GameEvent.new
        @games = Game.all.order(id: :desc)
    end


    def create
        @game_event = @game.game_events.build(game_event_params)
        @game_event.user_id = current_user.id
        if @game_event.save!
            redirect_to @game
        else
            render 'new'
        end
    end

    def edit
    end

    def show
    end

    def update
        @image_caches = []
        @_destroy_record = []
        if @game_event.update!(game_event_update_params)
            redirect_to game_event_path(id: @game_event.id, game_id: @game_event.game.id)
        else
            render 'edit'
        end
    end

    def destroy
        @game_event.destroy
        redirect_to @game
    end

    private

    def user_auth_check
        if user_signed_in?
            if @game_event.user_id != current_user.id
                redirect_to root_path and return
            end
        end
    end


    def parent_game_find
        @game = Game.find params[:game_id]
    end

    def game_event_params
        params.require(:game_event).permit(:title,:file_url, :body,:image, :event_date, :twitter_render, :event_master,
                                           game_event_tags_attributes: [:tag_name])
    end

    def game_event_update_params
        params.require(:game_event).permit(:title,:file_url, :body,:image, :event_date, :twitter_render, :event_master,
            game_event_tags_attributes: [:id, :tag_name, :_destroy, :game_event_id])
    end


    def game_event_find
        @game_event = GameEvent.find params[:id]
    end
end
