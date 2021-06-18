require 'rails_helper'

RSpec.describe "GameEvents", type: :request do
  before(:each) do
    @user = User.create!(password: "aaaaaa", email: "a@a", name: "testMan")
    @user_admin = User.create!(password: "aaaaaa", email: "admin@admin", name: "AdminMan", admin: true)
    @game = @user_admin.games.create!(title: "Game1")
    @game_event = @game.game_events.create!(title: "GameEvent1", event_master: "MasterMan", event_date: Date.today, user_id: @user.id)
    @game_event2 = @game.game_events.create!(user_id: @user_admin.id, title: "GameEvent2", event_master: "event_master2")
    # sign_in @user
  end
  describe "ログインしていない場合" do
    context "index" do
      it "indexが表示できる" do
        get game_events_path(game_id: @game.id, id: @game_event.id)
        expect(response.status).to eq 200
      end
    end
    context "new" do
      it "newが表示できない" do
        get new_game_event_path(id: @game_event.id, game_id: @game.id)
        expect(response.status).to_not eq 200
        expect(response.status).to be >= 300
        expect(response.status).to be < 400
      end
    end
    context "game_event_new" do
      it "game_event_newが表示できない" do
        get game_events_new_path
        expect(response.status).to_not eq 200
        expect(response.status).to be >= 300
        expect(response.status).to be < 400
      end
    end
    context "create" do
      it "createにアクセスできない" do
        post game_game_events_path(game_id: @game.id)
        expect(response.status).to_not eq 200
        expect(response.status).to be >= 300
        expect(response.status).to be < 400
      end
    end
    context "edit" do
      it "editにアクセスできない" do
        get edit_game_event_path(id: @game_event.id, game_id: @game_event.game.id)
        expect(response.status).to_not eq 200
        expect(response.status).to be >= 300
        expect(response.status).to be < 400
      end
    end
    context "show" do
      it "showがひょうじされる" do
        get game_event_path(id: @game_event.id, game_id: @game_event.game.id)
        expect(response.status).to eq 200

      end
    end

    context "update" do
      it "updateにアクセスできない" do
        put game_event_path(id: @game_event.id, game_id: @game_event.game_id)
        expect(response.status).to_not eq 200
        expect(response.status).to be >= 300
        expect(response.status).to be < 400
      end
    end

    context "destroy" do
      it "Destroyにアクセスできない" do
        delete game_event_path(id: @game_event.id, game_id: @game_event.game_id)
        expect(response.status).to_not eq 200
        expect(response.status).to be >= 300
        expect(response.status).to be < 400
      end
    end

    context "game_events_create" do
      it "game_events_createにアクセスできない" do
        post game_game_events_path(game_id: @game.id)
        expect(response.status).to_not eq 200
        expect(response.status).to be >= 300
        expect(response.status).to be < 400   
      end
    end
    describe "ログインしている場合" do
      before(:each) do
        sign_in @user
      end
      context "index" do
        it "indexにアクセスできる" do 
          get game_events_path(game_id: @game.id)
          expect(response.status).to eq 200
        end
      end
      context "new" do
        it "newにアクセスできる" do 
          get new_game_event_path(game_id: @game.id)
          expect(response.status).to eq 200
        end
      end

      context "edit" do
        it "editにアクセスできる && 投稿したユーザーだったらアクセスできる" do
          get edit_game_event_path(game_id: @game.id, id: @game_event.id)
          expect(response.status).to eq 200
        end
        it "editにアクセスできる && 投稿したユーザーじゃなかったらはじく" do
          get edit_game_event_path(game_id: @game.id, id: @game_event2.id)
          expect(response.status).to_not eq 200
          expect(response.status).to be >= 300
          expect(response.status).to be < 400
        end
      end

      context "game_event_new" do
        it "game_event_newにアクセスできる" do 
          get game_events_new_path
          expect(response.status).to eq 200
        end
      end

      context "create" do
        it "createに成功 && createにアクセスできる && redirect" do 
          post game_game_events_path(game_id: @game.id, game_event: {title: "Title", event_master: "Master", event_date: Date.today})
          expect(response.status).to eq 302
        end

        it "createに失敗 && createにアクセスできる && render" do
          #event_masterがないからvalidationエラーが出る。
          post game_game_events_path(game_id: @game.id, game_event: {title: "rwrw", event_master: ""})
          expect(response.body).to include "エラーが見つかりました"
        end 
      end

      context "game_events_create" do
        it "game_events_createにアクセスできる && createに成功 && redirect" do
          post game_game_events_path(game_id: @game.id, game_event: {title: "test", event_master: "testsan"})
          expect(response.status).to eq 302
        end
        it "game_events_createにアクセスできる && createに失敗 && render" do
          post game_game_events_path(game_id: @game.id, game_event: {title: "", event_master: "master"})
          expect(response.body).to include "エラーが見つかりました"
        end
      end

      context "update" do
        it "updateに成功 && updateにアクセスできる && 投稿したユーザーだったら && redirect" do
          put game_event_path(game_id: @game.id, id: @game_event.id, game_event: {title: "titleUpdate", event_master: "titleUpdate"})
          expect(response.status).to eq 302
        end
        it "updateに失敗 && 投稿したユーザーだったら && render && updateにアクセスできる" do
          put game_event_path(game_id: @game.id, id: @game_event.id, game_event: {title: "", event_master: ""})
          expect(response.body).to include "エラーが見つかりました。"
        end
        it "updateにアクセスできる && 投稿したユーザーじゃなかったらレダイレクトする" do
          #@userでログインしているがそこに別ユーザーが作ったGameEventを更新しようとすると、はじかれる
          put game_event_path(game_id: @game.id, id: @game_event2.id, game_event: {title: "titleUpdate", event_master: "titleUpdate"})
          expect(response.status).to_not eq 200
          expect(response.status).to be >= 300
          expect(response.status).to be < 400
        end
      end

      context "destroy" do
        #destroyは失敗のことは考えてない
        it "destroyに成功 && 投稿したユーザーだったら && redirect" do
          delete game_event_path(game_id: @game.id, id: @game_event.id)
          expect(response.status).to eq 302
        end
        it "投稿したユーザーじゃなかったらはじく" do
          delete game_event_path(game_id: @game.id, id: @game_event2.id)
          expect(response.status).to_not eq 200
          expect(response.status).to be >= 300
          expect(response.status).to be < 400
        end
      end
    end
  end

end
