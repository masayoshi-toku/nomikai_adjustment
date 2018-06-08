require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include GoogleOmniauthHelper
  # describe "GET #index" do
  #   it "returns a success response" do
  #     user = User.create! valid_attributes
  #     get :index, params: {}
  #     expect(response).to be_success
  #   end
  # end
  #
  # describe "GET #show" do
  #   it "returns a success response" do
  #     user = User.create! valid_attributes
  #     get :show, params: {id: user.to_param}
  #     expect(response).to be_success
  #   end
  # end

  describe "GET #new" do
    it "ページが表紙される" do
      get :new
      expect(response).to be_success
    end
  end

  # describe "GET #edit" do
  #   it "returns a success response" do
  #     user = User.create! valid_attributes
  #     get :edit, params: {id: user.to_param}
  #     expect(response).to be_success
  #   end
  # end
  #

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

  #
  # describe "PUT #update" do
  #   context "with valid params" do
  #     let(:new_attributes) {
  #       skip("Add a hash of attributes valid for your model")
  #     }
  #
  #     it "updates the requested user" do
  #       user = User.create! valid_attributes
  #       put :update, params: {id: user.to_param, user: new_attributes}
  #       user.reload
  #       skip("Add assertions for updated state")
  #     end
  #
  #     it "redirects to the user" do
  #       user = User.create! valid_attributes
  #       put :update, params: {id: user.to_param, user: valid_attributes}
  #       expect(response).to redirect_to(user)
  #     end
  #   end
  #
  #   context "with invalid params" do
  #     it "returns a success response (i.e. to display the 'edit' template)" do
  #       user = User.create! valid_attributes
  #       put :update, params: {id: user.to_param, user: invalid_attributes}
  #       expect(response).to be_success
  #     end
  #   end
  # end
  #
  # describe "DELETE #destroy" do
  #   it "destroys the requested user" do
  #     user = User.create! valid_attributes
  #     expect {
  #       delete :destroy, params: {id: user.to_param}
  #     }.to change(User, :count).by(-1)
  #   end
  #
  #   it "redirects to the users list" do
  #     user = User.create! valid_attributes
  #     delete :destroy, params: {id: user.to_param}
  #     expect(response).to redirect_to(users_url)
  #   end
  # end

end
