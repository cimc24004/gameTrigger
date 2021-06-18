require 'rails_helper'

RSpec.describe "Games", type: :request do
  before(:each) do
    @user = User.create!(password: "aaaaaa", email: "a@a", name: "testMan")
    @user_admin = User.create!(password: "aaaaaa", email: "admin@admin", name: "AdminMan", admin: true)
    @game = @user_admin.games.create!(title: "Game1", image: nil)
    @game2 = @user_admin.games.create!(title: "Game2", image: nil)
    # sign_in @user
  end

  describe "ログインしていない場合" do
    context "index" do
      it "indexにアクセスできる" do
        get games_path
        expect(response.status).to eq 200
      end
    end
    context "new" do
      it "newにアクセスできない" do
        get new_game_path
        expect(response.status).to_not eq 200
        expect(response.status).to be >= 300
        expect(response.status).to be < 400
      end
    end
    context "edit" do 
      it "editにアクセスできない" do
        get edit_game_path(@game)
        expect(response.status).to_not eq 200
        expect(response.status).to be >= 300
        expect(response.status).to be < 400
      end
    end
    context "create" do
      it "createにアクセスできない" do
        post games_path(game: {title: "test"})
        expect(response.status).to_not eq 200
        expect(response.status).to be >= 300
        expect(response.status).to be < 400
      end
    end
    context "update" do
      it "updateにアクセスできない" do
        put game_path(id: @game.id,game: {title: "test"})
        expect(response.status).to_not eq 200
        expect(response.status).to be >= 300
        expect(response.status).to be < 400 
      end
    end
    context "show" do
      it "showにアクセスできる" do
        get game_path(@game)
        expect(response.status).to eq 200
      end
    end
    context "destroy" do
      it "destroyにアクセスできない" do
        delete game_path(@game)
        expect(response.status).to_not eq 200
        expect(response.status).to be >= 300
        expect(response.status).to be < 400         
      end
    end
  end
  describe "ログインしている場合" do
    context "index" do
      it "indexにアクセスできる" do
        get games_path
        expect(response.status).to eq 200
      end
    end
    context "new" do
      it "管理者だったらアクセスできる" do
        sign_in @user_admin
        get new_game_path
        expect(response.status).to eq 200
      end
      it "管理者じゃないのでアクセスできない" do
        sign_in @user
        get new_game_path
        expect(response.status).to_not eq 200
        expect(response.status).to be >= 300
        expect(response.status).to be < 400       
      end
    end
    context "edit" do 
      it "管理者だったらeditアクセスできる" do
        sign_in @user_admin
        get edit_game_path(@game)
        expect(response.status).to eq 200
      end
      it "管理者じゃなかったらeditにアクセスできない" do
        sign_in @user
        get edit_game_path(@game)
        expect(response.status).to_not eq 200
        expect(response.status).to be >= 300
        expect(response.status).to be < 400           
      end
    end
    context "create" do
      it "管理者だったらcreateできる" do
        sign_in @user_admin
        post games_path(game: {title: "test"})
        expect(response.status).to eq 302
      end
      it "管理者じゃなかったらcreateできない" do
        sign_in @user
        post games_path(game: {title: "test"})
        expect(response.status).to_not eq 200
        expect(response.status).to be >= 300
        expect(response.status).to be < 400        
      end
    end
    context "update" do
      it "管理者だったらupdateできる" do
        sign_in @user_admin
        put game_path(@game, game: {title: "test_update"})
        expect(response.status).to eq 302
      end
      it "管理者じゃなかったらupdateできない" do
        sign_in @user
        put game_path(@game, game: {title: "test_update"})
        expect(response.status).to_not eq 200
        expect(response.status).to be >= 300
        expect(response.status).to be < 400     
      end
    end
    context "show" do
      it "showにアクセスできる" do
        sign_in @user

        get game_path(@game)
        expect(response.status).to eq 200
      end
    end
    context "destroy" do
      it "管理者だったらdestroyできる" do
        sign_in @user_admin
        delete game_path(@game)
        expect(response.status).to eq 302
      end
      it "管理者じゃなかったらdestroyできない" do
        sign_in @user
        delete game_path(@game)
        expect(response.status).to_not eq 200
        expect(response.status).to be >= 300
        expect(response.status).to be < 400
      end
    end
  end
end
