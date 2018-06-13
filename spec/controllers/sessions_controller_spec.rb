require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  include GoogleOmniauthHelper
  include SessionHelper

  describe "GET #new" do
    it "リクエストが成功する" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #create" do
    context "ログイン" do
      before do
        create(:user)
        @valid_attributes = attributes_for(:user).merge(domain: 'mwed.co.jp')
        request.env['omniauth.auth'] = google_mock(@valid_attributes)
        get :create, params: { provider: 'google_auth2' }
      end

      it "ログインしてユーザーの詳細ページへリダイレクトする" do
        user = User.find_by(email: @valid_attributes[:email])
        expect(is_logged_in?).to be true
        should redirect_to user
      end
    end

    context "サインアップ" do
      before do
        create(:user)
      end

      context "正しいパラメーターの場合" do
        before do
          @valid_attributes = { name: 'Mr.example2', email: 'other_example@mwed.co.jp', domain: 'mwed.co.jp' }
          request.env['omniauth.auth'] = google_mock(@valid_attributes)
        end

        it "ユーザーが作成される" do
          expect{ get :create, params: { provider: 'google_auth2' } }.to change { User.count }.by(1)
        end

        it "ログインしてユーザーの詳細ページへリダイレクトする" do
          get :create, params: { provider: 'google_auth2' }
          user = User.find_by(email: @valid_attributes[:email])
          expect(is_logged_in?).to be true
          assert_redirected_to user
        end
      end

      context "不正なパラメーターの場合" do
        subject { get :create, params: { provider: 'google_auth2' } }

        context "ドメインが不正の場合" do
          before do
            invalid_attributes = { name: 'Mr.wrong_example', email: 'example@gmail.com', domain: 'gmail.com' }
            request.env['omniauth.auth'] = google_mock(invalid_attributes)
          end

          it { should redirect_to root_url }
        end
      end
    end
  end
end
