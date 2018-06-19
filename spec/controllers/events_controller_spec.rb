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

    context "ログイン済みの場合" do
      before do
        event
        log_in(event.user)
      end

      context "イベントが存在する場合" do
        let(:params) { { url_path: event.url_path } }

        it { is_expected.to be_successful }
      end

      context "イベントが存在しない場合" do
        let(:params) { { url_path: event.url_path.split('').shuffle.join } }

        it { is_expected.to redirect_to events_url }
      end
    end

    context "ログインしていない場合" do
      let(:params) { { url_path: event.url_path } }

      it { is_expected.to redirect_to root_url }
    end
  end

  describe "GET #new" do
    subject { get :new }

    context "ログイン済みの場合" do
      before do
        event
        log_in(event.user)
      end

      it { is_expected.to be_successful }
    end

    context "ログインしていない場合" do
      it { is_expected.to redirect_to root_url }
    end
  end

  describe "GET #edit" do
    subject { get :edit, params: params }

    context "ログイン済みの場合" do
      before do
        event
        log_in(event.user)
      end

      context "イベントが存在する場合" do
        let(:params) { { url_path: event.url_path } }

        it { is_expected.to be_successful }
      end

      context "イベントが存在しない場合" do
        let(:params) { { url_path: event.url_path.split('').shuffle.join } }

        it { is_expected.to redirect_to events_url }
      end
    end

    context "ログインしていない場合" do
      let(:params) { { url_path: event.url_path } }

      it { is_expected.to redirect_to root_url }
    end
  end

  describe "POST #create" do
    context "ログイン済みの場合" do
      before do
        event
        log_in(event.user)
      end

      context "正しいパラメーターの場合" do
        subject { proc { post :create, params: { event_form: valid_attributes } } }

        it { is_expected.to change{ Event.count }.by(1) }

        it "イベントの詳細ページへリダイレクトする" do
          subject.call
          event = Event.find_by(title: valid_attributes[:title])
          expect(response).to redirect_to event.url_path
        end
      end

      context "不正なパラメーターの場合" do
        subject { post :create, params: { event_form: attributes } }

        context "タイトルが空の場合" do
          let(:attributes) { { title: '', event_dates_text: "2018/06/18\r\n2018/06/19\r\n2018/06/20" } }

          it { is_expected.to render_template(:new) }
        end
      end
    end

    context "ログインしていない場合" do
      subject { post :create, params: { event_form: valid_attributes } }

      it { is_expected.to redirect_to root_path }
    end
  end

  describe "PUT #update" do
    context "ログイン済みの場合" do
      before do
        event
        log_in(event.user)
      end

      context "正しいパラメーターの場合" do
        before do
          old_title
          put :update, params: { url_path: event.url_path, event_form: attributes }
        end

        let(:old_title) { event.title }
        let(:attributes) { { title: '新飲み会テストタイトル' } }
        let(:updated_event) { Event.find_by(url_path: event.url_path) }

        it { expect(updated_event.title).not_to eq old_title }

        it { is_expected.to redirect_to updated_event }
      end

      context "不正なパラメーターの場合" do
        subject { put :update, params: { url_path: event_url_path, event_form: attributes } }

        context "イベントが存在しない場合" do
          let(:attributes) { { title: '飲み会テストタイトル' } }
          let(:event_url_path) { event.url_path.split('').to_a.shuffle.join }

          it { is_expected.to render_template(:edit) }
        end

        context "タイトルが空の場合" do
          let(:attributes) { { title: '' } }
          let(:event_url_path) { event.url_path }

          it { is_expected.to render_template(:edit) }
        end
      end
    end

    context "ログインしていない場合" do
      subject { put :update, params: { url_path: event.url_path, event_form: attributes } }
      let(:attributes) { { title: '飲み会テストタイトル' } }

      it { is_expected.to redirect_to root_path }
    end
  end

  describe "DELETE #destroy" do
    subject { delete :destroy, params: params }
    before{ event }

    context "ログイン済みの場合" do
      before do
        event
        log_in(event.user)
      end

      context "イベントが存在する場合" do
        let(:params) { { url_path: event.url_path } }

        it { expect{ subject }.to change{ Event.count }.by(-1) }

        it { is_expected.to redirect_to events_url }
      end

      context "イベントが存在しない場合" do
        let(:params) { { url_path: event.url_path.split('').to_a.shuffle.join } }

        it { is_expected.to render_template(:index) }
      end
    end

    context "ログインしていない場合" do
      let(:params) { { url_path: event.url_path } }

      it { is_expected.to redirect_to root_url }
    end
  end
end
