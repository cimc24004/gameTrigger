require 'rails_helper'

RSpec.describe User, type: :model do
  

  describe "ログインしている場合" do
    before(:each) do
      @user = User.create!(email: "a@a", password: "aaaaaa", name: "test", remember_created_at: Time.now)
      sign_in @user
    end
    # context "時間でタイムアウトSessionはかいしてログアウト" do
    #   it "1ヶ月以上たったら" do
    #     travel_to('2021-07-26'.to_date)

    #     @date = Date.parse(@user.remember_created_at.to_s)

    #     expect(@date.year).to eq Time.current.year
    #     expect(@date.month).to eq Time.current.month - 1
    #     expect(@date.day).to eq Time.current.day
    #   end
    # end
  end

  describe "ログインしていない場合Createする" do
    context "User Create" do
      it "名前を入力していない場合エラーが出る" do
        @user = User.create(email: "a@a1", password: "aaaaaa1", name: nil)
        binding.pry
        expect(@user.errors.present?).to eq true
      end
    end
    
  end
end
