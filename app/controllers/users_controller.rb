class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :user_find
    before_action :user_auth_check
    def show
        @game_events = @user.game_events.includes(:user)
    end

    private

    def user_find
        @user = User.find params[:id]
    end

    def user_auth_check
        if @user.id != current_user.id
            redirect_to root_path and return
        end
    end
end
