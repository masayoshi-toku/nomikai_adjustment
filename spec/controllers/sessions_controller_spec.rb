require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  include GoogleOmniauthTestHelper
  include SessionTestHelper
  let(:valid_attributes) { attributes_for(:user).merge(domain: 'mwed.co.jp') }

  describe "GET #new" do
    subject { get :new }
    it { is_expected.to have_http_status(:success) }
  end

  describe "GET #create" do
    context "ログイン" do
      before do
        create(:user)
        request.env['omniauth.auth'] = google_mock(valid_attributes)
        get :create, params: { provider: 'google_auth2' }
      end

      it { expect(is_logged_in?).to be true }

      it "イベント一覧ページへリダイレクトする" do
        user = User.find_by(email: valid_attributes[:email])
        expect(response).to redirect_to events_url
      end
    end

    context "サインアップ" do
      subject { get :create, params: { provider: 'google_auth2' } }

      context "正しいパラメーターの場合" do
        let(:other_valid_attributes) { { name: 'Mr.example2', email: 'other_example@mwed.co.jp', domain: 'mwed.co.jp' } }
        before { request.env['omniauth.auth'] = google_mock(other_valid_attributes) }

        it { expect{ subject }.to change { User.count }.by(1) }

        it "ログインに成功する" do
          is_expected.to be_truthy
          expect(is_logged_in?).to be true
        end

        it "イベント一覧ページへリダイレクトする" do
          is_expected.to be_truthy
          user = User.find_by(email: other_valid_attributes[:email])
          expect(response).to redirect_to events_url
        end
      end

      context "不正なパラメーターの場合" do
        context "ドメインが不正の場合" do
          let(:invalid_attributes) { { name: 'Mr.wrong_example', email: 'example@gmail.com', domain: 'gmail.com' } }
          before { request.env['omniauth.auth'] = google_mock(invalid_attributes) }

          it { is_expected.to redirect_to root_url }
        end
      end
    end
  end

  describe "DELETE #destroy" do
    subject { delete :destroy }

    context "ログイン済みの場合" do
      let(:user) { create(:user) }
      before { log_in(user) }

      it "ログアウトに成功する" do
        expect(is_logged_in?).to be true
        is_expected.to redirect_to root_url
        expect(is_logged_in?).to be false
      end
    end

    context "ログインをしていない場合" do
      it { is_expected.to redirect_to root_url }
    end
  end
end
