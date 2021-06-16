class GameEventsController < ApplicationController
    
    before_action :authenticate_user!, only: [:create, :destroy, :update, :new, :edit, :game_events_new]
    before_action :parent_game_find, only: [:create, :new, :show, :update, :destroy, :edit]
    before_action :game_event_find, only: [:show, :update, :destroy, :edit]
    before_action :user_auth_check, only: [:destroy, :update, :edit]
    before_action :lists_receive
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
        @lists.push("title" => "ゲーム大会一覧", "link" => "")
    end

    def new
        @lists.push("title" => "#{@game.title.truncate(10)}の大会一覧", "link" => "#{game_path(@game)}")
        @lists.push("title" => "#{@game.title.truncate(10)}の大会情報を登録", "link" => "")

        @game_event = @game.game_events.build
    end

    def game_events_new
        @lists.push("title" => "大会情報を登録", "link" => "")
        @game_event = GameEvent.new
        @games = Game.all.order(id: :desc)
        @default_value = nil
    end


    def create
        @game_event = @game.game_events.build(game_event_params)
        @game_event.user_id = current_user.id
        if @game_event.save
            redirect_to @game
        else
            render 'new'
        end
    end

    def edit
        @lists.push("title" => "#{@game_event.game.title.truncate(10)}の大会一覧", "link" => "#{game_path(@game)}")
        @lists.push("title" => "#{@game_event.title.truncate(10)}の大会情報", "link" => "#{game_event_path(id: @game_event.id, game_id: @game_event.game.id)}")
        @lists.push("title" => "#{@game_event.title}の編集", "link" => "")
    end

    def show
        @lists.push("title" => "#{@game_event.game.title.truncate(10)}の大会一覧", "link" => "#{game_path(@game)}")
        @lists.push("title" => "#{@game_event.title.truncate(10)}の大会情報", "link" => "")
    end

    def update
        image_upload = false
        if @game_event.google_file_id.present?
            image_upload = true
        end
        if @game_event.update(game_event_update_params)
            if @game_event.image.present?
                if image_upload
                    @game_event.game_event_image_update_to_google_drive
                else
                    @game_event.game_event_image_upload_to_google_drive
                end
            end
            redirect_to game_event_path(id: @game_event.id, game_id: @game_event.game.id)
        else
            render 'edit'
        end
    end

    def destroy
        @game_event.destroy
        redirect_to @game
    end

    def game_events_create
        if params[:game_event][:game_id].blank?
            @game_event = GameEvent.new(game_event_params)
            @game_event.errors.add(:game_id, "を選択してください。")
            @games = Game.all.order(id: :desc)
            render 'game_events_new' and return
        end
        @game = Game.find params[:game_event][:game_id]
        @game_event = @game.game_events.build(game_event_params)
        @game_event.user_id = current_user.id
        if @game_event.save
            redirect_to @game
        else
            @games = Game.all.order(id: :desc)
            @default_value = params[:game_event][:game_id]
            cookies[:search_game_id] = @default_value
            render 'game_events_new'
        end
    end
    private

    def user_auth_check
        if user_signed_in?
            if @game_event.user_id != current_user.id
                redirect_to root_path and return
            end
        end
    end

    def lists_receive
        #[{"title" => "", "link" => ""]}
        @lists = []
    end

    def parent_game_find
        @game = Game.find params[:game_id]
    end

    def game_event_params
        params.require(:game_event).permit(:title,:file_url, :body,:image, :event_date, :twitter_render,:image_cache, :event_master,
                                           game_event_tags_attributes: [:tag_name])
    end

    def game_event_update_params
        params.require(:game_event).permit(:title,:file_url, :body,:image, :event_date, :twitter_render,:image_cache, :event_master,
            game_event_tags_attributes: [:id, :tag_name, :_destroy, :game_event_id])
    end


    def game_event_find
        @game_event = GameEvent.find params[:id]
    end
end
