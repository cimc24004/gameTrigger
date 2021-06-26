require 'rails_helper'

RSpec.describe GameEvent, type: :model do
  describe "ログインしている場合" do
    before(:each) do
      @user = User.create!(email: "a@a", password: "aaaaaa", name: "test", remember_created_at: Time.now)
      sign_in @user
    end
  end
end
