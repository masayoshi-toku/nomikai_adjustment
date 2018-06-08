require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include GoogleOmniauthHelper

  describe "GET #new" do
    before { get :new }
    it { expect(response).to be_success }
  end

  describe "POST #create" do
    context "正しいパラメーターの場合" do
      before do
        valid_attributes = { name: 'Mr.example', email: 'example@mwed.co.jp', domain: 'mwed.co.jp' }
        request.env['omniauth.auth'] = google_mock(valid_attributes)
      end

      it "ユーザー作成に成功する" do
        expect { post :create }.to change(User, :count).by(1)
      end

      it "ユーザーの詳細ページへリダイレクトされる" do
        post :create
        expect(response).to redirect_to(assigns(:user))
      end
    end

    context "不正なパラメーターの場合" do
      it "名前が空であればユーザー作成ページが描画される" do
        invalid_attributes = { name: '', email: 'example@mwed.co.jp', domain: 'mwed.co.jp' }
        request.env['omniauth.auth'] = google_mock(invalid_attributes)

        post :create
        expect(response).to redirect_to(new_user_url)
      end

      it "メールアドレスが空であればユーザー作成ページが描画される" do
        invalid_attributes = { name: 'Mr.example', email: '', domain: 'mwed.co.jp' }
        request.env['omniauth.auth'] = google_mock(invalid_attributes)

        post :create
        expect(response).to redirect_to(new_user_url)
      end

      it "ドメインが不正の場合はユーザー作成ページにリダイレクトされる" do
        invalid_attributes = { name: 'Mr.example', email: 'example@gmail.com', domain: 'gmail.com' }
        request.env['omniauth.auth'] = google_mock(invalid_attributes)

        post :create
        expect(response).to redirect_to(new_user_url)
      end
    end
  end
end
