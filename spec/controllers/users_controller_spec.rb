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
        created_user = User.find_by(email: 'example@mwed.co.jp')
        expect(response).to redirect_to created_user
      end
    end

    context "不正なパラメーターの場合" do
      subject { response }

      context "名前が空である" do
        before do
          invalid_attributes = { name: '', email: 'example@mwed.co.jp', domain: 'mwed.co.jp' }
          request.env['omniauth.auth'] = google_mock(invalid_attributes)
          post :create
        end

        it { is_expected.to redirect_to new_user_url }
      end

      context "メールアドレスが空である" do
        before do
          invalid_attributes = { name: 'Mr.example', email: '', domain: 'mwed.co.jp' }
          request.env['omniauth.auth'] = google_mock(invalid_attributes)
          post :create
        end

        it { is_expected.to redirect_to new_user_url }
      end

      context "ドメインが不正である" do
        before do
          invalid_attributes = { name: 'Mr.example', email: 'example@gmail.com', domain: 'gmail.com' }
          request.env['omniauth.auth'] = google_mock(invalid_attributes)
          post :create
        end

        it { is_expected.to redirect_to new_user_url }
      end
    end
  end
end
