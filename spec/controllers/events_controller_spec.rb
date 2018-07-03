require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:user) { create(:user) }
  let(:event) { create(:event, user: user) }
  let(:valid_attributes) {
    { title: '飲み会テストタイトル',
      event_dates_text: "6/18\r06/19\n06/20\r\n6/21\r\n\r\n6/22\n\n\n6/23\r\r\r\r6/24" }
   }

  describe "GET #index" do
    subject { get :index }

    it { is_expected.to be_successful }
  end

  describe "GET #show" do
    subject { get :show, params: params }

    context "ログイン済みの場合" do
      before do
        event
        log_in(user)
      end

      context "イベントが存在する場合" do
        let(:params) { { url_path: event.url_path } }

        it { is_expected.to be_successful }
      end

      context "イベントが存在しない場合" do
        let(:params) { { url_path: 'abc' } }

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
        log_in(user)
      end

      it { is_expected.to be_successful }
    end

    context "ログインしていない場合" do
      it { is_expected.to redirect_to root_url }
    end
  end

  describe "GET #edit" do
    subject { get :edit, params: { url_path: url_path } }

    context "ログイン済みの場合" do
      before do
        event
        log_in(login_user)
      end

      context "イベントが存在する場合" do
        context "ユーザーがイベント作成者の場合" do
          let(:login_user) { user }
          let(:url_path) { event.url_path }
          it { is_expected.to be_successful }
        end

        context "ユーザーがイベント作成者じゃない場合" do
          let(:login_user) { create(:user) }
          let(:url_path) { event.url_path }
          it { is_expected.to redirect_to events_url  }
        end
      end

      context "イベントが存在しない場合" do
        let(:login_user) { user }
        let(:url_path) { 'abc' }
        it { is_expected.to redirect_to events_url }
      end
    end

    context "ログインしていない場合" do
      let(:url_path) { event.url_path }
      it { is_expected.to redirect_to root_url }
    end
  end

  describe "POST #create" do
    context "ログイン済みの場合" do
      before do
        event
        log_in(user)
      end

      context "正しいパラメーターの場合" do
        subject { proc { post :create, params: { event_form: valid_attributes } } }

        it { is_expected.to change{ Event.count }.by(1) }
        it { is_expected.to change{ EventDate.count }.by(7) }

        it "イベントの詳細ページへリダイレクトする" do
          subject.call
          event = Event.find_by(title: valid_attributes[:title])
          expect(response).to redirect_to event_url(event.url_path)
        end
      end

      context "不正なパラメーターの場合" do
        subject { post :create, params: { event_form: attributes } }
        render_views

        context "タイトルが空の場合" do
          let(:attributes) { { title: '', event_dates_text: "2018/06/18\r\n2018/06/19\r\n2018/06/20" } }

          it { is_expected.to render_template(:new) }
        end

        context "タイトルと日付が空の場合" do
          before { log_in(user) }
          let(:attributes) { { title: '', event_dates_text: '' } }

          it { is_expected.to render_template(:new) }
        end
      end
    end

    context "ログインしていない場合" do
      subject { post :create, params: { event_form: valid_attributes } }

      it { is_expected.to redirect_to root_url }
    end
  end

  describe "PUT #update" do
    subject { put :update, params: { url_path: event.url_path, event_form: attributes } }

    context "ログイン済みの場合" do
      let(:event_date) { create(:event_date, event: event) }

      before do
        event_date
        log_in(login_user)
      end

      context "ユーザーがイベント作成者の場合" do
        let(:login_user) { user }

        context "正しいパラメーターの場合" do
          let!(:old_title) { event.title }
          let(:updated_event) { Event.find_by(url_path: event.url_path) }
          let(:deletable_event_dates) do
            deletable_event_dates = {}
            deletable_event_dates["#{event_date.id}"] = '1'
            deletable_event_dates
          end

          context "タイトルを変更する時" do
            let(:attributes) { { title: '新飲み会テストタイトル' } }

            it :aggregate_failures do
              is_expected.to redirect_to event_url(updated_event.url_path)
              expect(updated_event.title).not_to eq old_title
              expect(updated_event.title).to eq attributes[:title]
            end
          end

          context "タイトルを変更し、日付を削除する場合" do
            let!(:second_event_date) { create(:event_date, event: event) }
            let(:attributes) { { title: '新飲み会テストタイトル', deletable_event_dates: deletable_event_dates } }

            it :aggregate_failures do
              is_expected.to redirect_to event_url(updated_event.url_path)
              expect(updated_event.title).not_to eq old_title
              expect(updated_event.title).to eq attributes[:title]
            end

            it { expect{ subject }.to change{ EventDate.count }.by(-1) }
          end

          context "タイトルを変更し、日付を追加する場合" do
            let(:other_event_date) { build(:event_date, event: event) }
            let(:attributes) { { title: '新飲み会テストタイトル', event_dates_text: other_event_date.event_date } }

            it :aggregate_failures do
              is_expected.to redirect_to event_url(updated_event.url_path)
              expect(updated_event.title).not_to eq old_title
              expect(updated_event.title).to eq attributes[:title]
            end

            it { expect{ subject }.to change{ EventDate.count }.by(1) }
          end

          context "日付の追加と削除を同時に行う場合" do
            let(:other_event_date) { build(:event_date) }
            let(:attributes) { { event_dates_text: other_event_date.event_date, deletable_event_dates: deletable_event_dates } }

            it { expect{ subject }.to change{ EventDate.count }.by(0) }
          end

          context "タイトルの変更と日付の追加と削除を同時に行う場合" do
            let(:other_event_date) { build(:event_date) }
            let(:attributes) { { title: '新飲み会テストタイトル', event_dates_text: other_event_date.event_date, deletable_event_dates: deletable_event_dates } }

            it :aggregate_failures do
              is_expected.to redirect_to event_url(updated_event.url_path)
              expect(updated_event.title).not_to eq old_title
              expect(updated_event.title).to eq attributes[:title]
            end

            it :aggregate_failures do
              expect{ subject }.to change{ EventDate.count }.by(0)
              deleted_event_date = EventDate.find_by(id: event_date.id)
              created_event_date = EventDate.find_by(event_date: other_event_date.event_date)
              expect(deleted_event_date).to be nil
              expect(created_event_date).not_to be nil
            end
          end
        end

        context "不正なパラメーターの場合" do
          subject { put :update, params: { url_path: event_url_path, event_form: attributes } }

          context "イベントが存在しない場合" do
            let(:attributes) { { title: '飲み会テストタイトル' } }
            let(:event_url_path) { 'abc' }

            it { is_expected.to redirect_to events_url }
          end

          context "日付がすでに存在している場合" do
            let(:attributes) { { title: '飲み会テストタイトル', event_dates_text: event_date.event_date } }
            let(:event_url_path) { event.url_path }

            it { is_expected.to redirect_to edit_event_url(event.url_path) }
          end

          context "存在しない日付を削除する場合" do
            let(:attributes) { { title: '飲み会テストタイトル', deletable_event_dates: deletable_event_dates } }
            let(:event_url_path) { event.url_path }
            let(:deletable_event_dates) do
              deletable_event_dates = {}
              deletable_event_dates[100] = '1'
              deletable_event_dates
            end

            it { is_expected.to redirect_to event_url(event.url_path) }
          end
        end
      end

      context "ユーザーがイベント作成者じゃない場合" do
        let(:login_user) { create(:user) }
        let(:attributes) { { title: '新飲み会テストタイトル' } }

        it { is_expected.to redirect_to events_url }
      end
    end

    context "ログインしていない場合" do
      subject { put :update, params: { url_path: event.url_path, event_form: attributes } }
      let(:attributes) { { title: '飲み会テストタイトル' } }

      it { is_expected.to redirect_to root_url }
    end
  end

  describe "DELETE #destroy" do
    subject { delete :destroy, params: params }
    before { event }

    context "ログイン済みの場合" do
      before do
        event
        log_in(login_user)
      end

      context "ユーザーがイベント作成者の場合" do
        let(:login_user) { user }

        context "イベントが存在する場合" do
          let(:params) { { url_path: event.url_path } }

          it { expect{ subject }.to change{ Event.count }.by(-1) }
          it { is_expected.to redirect_to events_url }
        end

        context "イベントが存在しない場合" do
          let(:params) { { url_path: 'abc' } }

          it { is_expected.to redirect_to events_url }
        end
      end

      context "ユーザーがイベント作成者じゃない場合" do
        let(:login_user) { create(:user) }
        let(:params) { { url_path: event.url_path } }

        it { is_expected.to redirect_to events_url }
      end
    end

    context "ログインしていない場合" do
      let(:params) { { url_path: event.url_path } }

      it { is_expected.to redirect_to root_url }
    end
  end
end
