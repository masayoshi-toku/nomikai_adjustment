require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  include GoogleOmniauthHelper
  include SessionHelper
  let(:valid_attributes) { attributes_for(:user).merge(domain: 'mwed.co.jp') }

  describe "GET #new" do
    subject { get :new }
    it { is_expected.to have_http_status(:success) }
  end

  describe "GET #create" do
    subject { proc { get :create, params: { provider: 'google_auth2' } } }

    context "ログイン" do
      before do
        create(:user)
        request.env['omniauth.auth'] = google_mock(valid_attributes)
      end

      it "ログインに成功する" do
        subject.call
        expect(is_logged_in?).to be true
      end

      it "ユーザー詳細ページへリダイレクトする" do
        subject.call
        expect(response).to redirect_to User.last
      end
    end

    context "サインアップ" do
      context "正しいパラメーターの場合" do
        let(:other_valid_attributes) { { name: 'Mr.example2', email: 'other_example@mwed.co.jp', domain: 'mwed.co.jp' } }
        before { request.env['omniauth.auth'] = google_mock(other_valid_attributes) }

        it { is_expected.to change { User.count }.by(1) }

        it "ログインする" do
          subject.call
          expect(is_logged_in?).to be true
        end

        it "ユーザー詳細ページへリダイレクトする" do
          subject.call
          expect(response).to redirect_to User.last
        end
      end

      context "不正なパラメーターの場合" do
        context "ドメインが不正の場合" do
          let(:invalid_attributes) { { name: 'Mr.wrong_example', email: 'example@gmail.com', domain: 'gmail.com' } }
          before { request.env['omniauth.auth'] = google_mock(invalid_attributes) }

          it "トップページへリダイレクトする" do
            subject.call
            expect(response).to redirect_to root_url
          end
        end
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      request.env['omniauth.auth'] = google_mock(valid_attributes)
      get :create, params: { provider: 'google_auth2' }
    end

    it "ログアウトできる" do
      expect(is_logged_in?).to be true
      delete :destroy
      expect(is_logged_in?).to be false
    end
  end
end
