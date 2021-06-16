class UsersController < ApplicationController
    before_action :authenticate_user!, only: [:show]
    before_action :user_find, only: [:show]
    before_action :user_auth_check, only: [:show]
    before_action :lists_receive, only: [:show]

    def show
        @game_events = @user.game_events.includes(:user)
        @lists.push("title" => "マイページ", "link" => "")
    end

    def user_value_set
        if session['devise.omniauth_data'].blank? || user_signed_in?
            redirect_to root_path and return
        end
        @session = OmniAuth::AuthHash.new(session["devise.omniauth_data"])
        @user = User.new
    end

    def new
        if user_signed_in?
            redirect_to root_path and return
        end
    end

    private

    def lists_receive
        #[{"title" => "", "link" => ""]}
        @lists = []
    end

    def user_find
        @user = User.find params[:id]
    end

    def user_auth_check
        if @user.id != current_user.id
            redirect_to root_path and return
        end
    end
end
