require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  include SessionTestHelper
  let(:user) { create(:user) }
  let(:event) { create(:event) }
  let(:valid_attributes) { { title: '飲み会テストタイトル', event_dates_text: "2018/06/18\r\n2018/06/19\r\n2018/06/20" } }

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
      subject { proc { post :create, params: { event_form: valid_attributes } } }
      before { log_in(user) }

      it { is_expected.to change{ Event.count }.by(1) }

      it "イベントの詳細ページへリダイレクトする" do
        subject.call
        event = Event.find_by(title: valid_attributes[:title])
        expect(response).to redirect_to event
      end
    end

    context "不正なパラメーターの場合" do
      subject { post :create, params: { event_form: attributes } }

      context "作成者が不明な場合" do
        let(:attributes) { { title: '飲み会テストタイトル', event_dates_text: "2018/06/18\r\n2018/06/19\r\n2018/06/20" } }

        it { is_expected.to render_template(:new) }
      end

      context "タイトルが空の場合" do
        before { log_in(user) }
        let(:attributes) { { title: '', event_dates_text: "2018/06/18\r\n2018/06/19\r\n2018/06/20" } }

        it { is_expected.to render_template(:new) }
      end
    end
  end

  describe "PUT #update" do
    context "正しいパラメーターの場合" do
      before { put :update, params: { id: event.id, event_form: attributes } }

      let(:attributes) { { title: '飲み会テストタイトル2' } }
      let(:updated_event) { Event.find_by(title: attributes[:title]) }

      it { expect(updated_event.title).to eq attributes[:title] }

      it { is_expected.to redirect_to updated_event }
    end

    context "不正なパラメーターの場合" do
      subject { put :update, params: { id: event_id, event_form: attributes } }

      context "イベントが存在しない場合" do
        before do
          event
          log_in(event.user)
        end

        let(:attributes) { { title: '飲み会テストタイトル' } }
        let(:event_id) { event.id + 1 }

        it { is_expected.to render_template(:edit) }
      end

      context "タイトルが空の場合" do
        let(:attributes) { { title: '' } }
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
