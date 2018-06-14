require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:user) { create(:user) }
  let(:event) { create(:event) }
  let(:valid_attributes) { { user_id: user.id, title: '飲み会テストタイトル', url_path: 'this.is%validattirbutes' } }

  describe "GET #show" do
    subject { get :show, params: { id: event.id } }

    it { is_expected.to be_successful }
  end

  describe "GET #new" do
    subject { get :new, params: { id: event.id } }

    it { is_expected.to be_successful }
  end

  describe "GET #edit" do
    subject { get :edit, params: { id: event.id } }

    it { is_expected.to be_successful }
  end

  describe "POST #create" do
    context "正しいパラメーターの場合" do
      subject { proc { post :create, params: { event: valid_attributes } } }

      it { is_expected.to change(Event, :count).by(1) }

      it "イベントの詳細ページへリダイレクトする" do
        subject.call
        expect(response).to redirect_to Event.last
      end
    end
  end

  describe "PUT #update" do
    context "正しいパラメーターの場合" do
      subject { proc { put :update, params: { id: event.id, event: new_attributes } } }
      let(:new_attributes) { { user_id: event.user_id, title: '飲み会テストタイトル2', url_path: 'this.is%validattirbutes' } }

      it "イベントを更新する" do
        subject.call
        expect(Event.last.title).to eq new_attributes[:title]
      end

      it "イベントの詳細ページへリダイレクトする" do
        subject.call
        expect(response).to redirect_to Event.last
      end
    end
  end

  describe "DELETE #destroy" do
    subject { proc { delete :destroy, params: { id: event.id } } }
    before{ event }

    it { is_expected.to change(Event, :count).by(-1) }

    it "イベントの一覧ページへリダイレクトする" do
      subject.call
      expect(response).to redirect_to events_url
    end
  end
end
