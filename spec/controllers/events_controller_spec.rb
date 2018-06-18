require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:user) { create(:user) }
  let(:event) { create(:event) }
  let(:valid_attributes) { { user_id: user.id, title: '飲み会テストタイトル', url_path: 'this.is%validattirbutes' } }

  describe "GET #index" do
    subject { get :index }

    it { is_expected.to be_successful }
  end

  describe "GET #show" do
    subject { get :show, params: params }

    context "イベントが存在する場合" do
      let(:params) { { id: event.id } }

      it { is_expected.to be_successful }
    end

    context "イベントが存在しない場合" do
      let(:params) { { id: event.id + 1 } }

      it { is_expected.to redirect_to events_url }
    end
  end

  describe "GET #new" do
    subject { get :new }

    it { is_expected.to be_successful }
  end

  describe "GET #edit" do
    subject { get :edit, params: params }

    context "イベントが存在する場合" do
      let(:params) { { id: event.id } }

      it { is_expected.to be_successful }
    end

    context "イベントが存在しない場合" do
      let(:params) { { id: event.id + 1 } }

      it { is_expected.to redirect_to events_url }
    end
  end

  describe "POST #create" do
    context "正しいパラメーターの場合" do
      subject { proc { post :create, params: { event: valid_attributes } } }

      it { is_expected.to change{ Event.count }.by(1) }

      it "イベントの詳細ページへリダイレクトする" do
        subject.call
        event = Event.find_by(valid_attributes)
        expect(response).to redirect_to event
      end
    end

    context "不正なパラメーターの場合" do
      subject { post :create, params: { event: invalid_attributes } }

      context "作成者が不明な場合" do
        let(:invalid_attributes) { { user_id: nil, title: '飲み会テストタイトル', url_path: 'this.is%validattirbutes' } }

        it { is_expected.to render_template(:new) }
      end

      context "タイトルが空の場合" do
        let(:invalid_attributes) { { user_id: user.id, title: '', url_path: 'this.is%validattirbutes' } }

        it { is_expected.to render_template(:new) }
      end

      context "イベントURLが空の場合" do
        let(:invalid_attributes) { { user_id: user.id, title: '飲み会テストタイトル', url_path: '' } }

        it { is_expected.to render_template(:new) }
      end
    end
  end

  describe "PUT #update" do
    context "正しいパラメーターの場合" do
      before do
        put :update, params: { id: event.id, event: new_attributes }
      end

      let(:new_attributes) { { user_id: event.user_id, title: '飲み会テストタイトル2', url_path: 'this.is%validattirbutes' } }
      let(:updated_event) { Event.find_by(new_attributes) }

      it { expect(updated_event.title).to eq new_attributes[:title] }

      it { is_expected.to redirect_to updated_event }
    end

    context "不正なパラメーターの場合" do
      subject { put :update, params: { id: event_id, event: invalid_attributes } }

      context "イベントが存在しない場合" do
        let(:invalid_attributes) { { user_id: event.user_id, title: '飲み会テストタイトル', url_path: 'this.is%validattirbutes' } }
        let(:event_id) { event.id + 1 }

        it { is_expected.to render_template(:edit) }
      end

      context "イベント作成者が不明な場合" do
        let(:invalid_attributes) { { user_id: nil, title: '飲み会テストタイトル', url_path: 'this.is%validattirbutes' } }
        let(:event_id) { event.id }

        it { is_expected.to render_template(:edit) }
      end

      context "タイトルが空の場合" do
        let(:invalid_attributes) { { user_id: event.user_id, title: '', url_path: 'this.is%validattirbutes' } }
        let(:event_id) { event.id }

        it { is_expected.to render_template(:edit) }
      end

      context "イベントURLが空の場合" do
        let(:invalid_attributes) { { user_id: event.user_id, title: '飲み会テストタイトル', url_path: '' } }
        let(:event_id) { event.id }

        it { is_expected.to render_template(:edit) }
      end
    end
  end

  describe "DELETE #destroy" do
    subject { delete :destroy, params: params }
    before{ event }

    context "イベントが存在する場合" do
      let(:params) { { id: event.id } }

      it { expect{ subject }.to change{ Event.count }.by(-1) }

      it { is_expected.to redirect_to events_url }
    end

    context "イベントが存在しない場合" do
      let(:params) { { id: event.id + 1 } }

      it { is_expected.to render_template(:index) }
    end
  end
end
