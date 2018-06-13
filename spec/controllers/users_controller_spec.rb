require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #index" do
    it "リクエストが成功する" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "リクエストが成功する" do
      user = create(:user)
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = create(:user)
    end

    it "ユーザー一覧ページへリダイレクトする" do
      delete :destroy, params: { id: @user.id }
      should redirect_to users_url
    end

    it "ユーザーが削除される" do
      expect{ delete :destroy, params: { id: @user.id } }.to change { User.count }.by(-1)
    end
  end
end
