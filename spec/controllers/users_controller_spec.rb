require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe "GET #show" do
    subject { get :show, params: params }

    context "ユーザーが存在する場合" do
      let(:params) { { id: user.id } }

      it { is_expected.to have_http_status(:success) }
    end

    context "ユーザーが存在しない場合" do
      let(:params) { { id: user.id + 1 } }

      it { is_expected.to redirect_to users_url }
    end
  end
end
