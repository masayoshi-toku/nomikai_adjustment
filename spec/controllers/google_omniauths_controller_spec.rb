require 'rails_helper'

RSpec.describe GoogleOmniauthsController, type: :controller do
  include GoogleOmniauthHelper

  describe "GET #new" do
    context "サインアップ" do
      before do
        request.env['omniauth.params'] = { request_from: 'sign_up' }.with_indifferent_access
        create(:user)
      end

      context "正しいパラメーターの場合" do
        before do
          @valid_attributes = { name: 'Mr.example2', email: 'other_example@mwed.co.jp', domain: 'mwed.co.jp' }
          request.env['omniauth.auth'] = google_mock(@valid_attributes)
        end

        it "ユーザーが作成される" do
          expect{ get :new, params: { provider: 'google_auth2' } }.to change { User.count }.by(1)
        end

        it "ユーザーが作成されるユーザーの詳細ページへリダイレクトする" do
          get :new, params: { provider: 'google_auth2' }
          user = User.find_by(email: @valid_attributes[:email])
          assert_redirected_to user
        end
      end

      context "不正なパラメーターの場合" do
        subject { get :new, params: { provider: 'google_auth2' } }

        context "ドメインが不正である" do
          before do
            invalid_attributes = { name: 'Mr.wrong_example', email: 'example@gmail.com', domain: 'gmail.com' }
            request.env['omniauth.auth'] = google_mock(invalid_attributes)
          end

          it { should redirect_to root_url }
        end

        context "既にユーザーが登録されている" do
          before do
            invalid_attributes = { name: 'Mr.example', email: 'example@mwed.co.jp', domain: 'mwed.co.jp' }
            request.env['omniauth.auth'] = google_mock(invalid_attributes)
          end

          it { should redirect_to root_url }
        end
      end
    end

    context "ログイン" do
      before do
        request.env['omniauth.params'] = { request_from: 'login' }.with_indifferent_access
        create(:user)
      end

      context "正しいパラメーターの場合" do
        before do
          @valid_attributes = attributes_for(:user).merge(domain: 'mwed.co.jp')
          request.env['omniauth.auth'] = google_mock(@valid_attributes)
          get :new, params: { provider: 'google_auth2' }
        end

        it "ユーザーの詳細ページへリダイレクトされる" do
          user = User.find_by(email: @valid_attributes[:email])
          assert_redirected_to user
        end
      end

      context "不正なパラメーターの場合" do
        context "メールアドレスが異なる" do
          subject { get :new, params: { provider: 'google_auth2' } }

          before do
            invalid_attributes = { name: 'Mr.example', email: 'other_example@mwed.co.jp', domain: 'mwed.co.jp' }
            request.env['omniauth.auth'] = google_mock(invalid_attributes)
          end

          it { should redirect_to root_url }
        end
      end
    end
  end
end
